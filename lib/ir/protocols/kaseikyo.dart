import '../ir_protocol_types.dart';

const IrProtocolDefinition kaseikyoProtocolDefinition = IrProtocolDefinition(
  id: 'kaseikyo',
  displayName: 'Kaseikyo',
  description:
      'Kaseikyo (48-bit), LSB-first per byte.\n'
      'Vendor(16) + VendorParity(4) + Genre1(4) + Genre2(4) + Command(10) + ID(2) + XOR(8).',
  implemented: true,
  defaultFrequencyHz: 37000,
  fields: <IrFieldDef>[
    IrFieldDef(
      id: 'address',
      label: 'Address (4 bytes)',
      type: IrFieldType.string,
      required: true,
      maxLength: 11,
      hint: 'e.g., 80 02 20 00',
      helperText:
          'Address (4 bytes, hex). If ID byte is 00, finder-compatible packed ID bits may be taken from command bits 10..11.',
      maxLines: 1,
    ),
    IrFieldDef(
      id: 'command',
      label: 'Command (4 bytes)',
      type: IrFieldType.string,
      required: true,
      maxLength: 11,
      hint: 'e.g., D0 03 00 00',
      helperText: 'Command (4 bytes, hex).',
      maxLines: 1,
    ),
  ],
);

class KaseikyoProtocolEncoder implements IrProtocolEncoder {
  static const String protocolId = 'kaseikyo';
  const KaseikyoProtocolEncoder();

  @override
  String get id => protocolId;

  @override
  IrProtocolDefinition get definition => kaseikyoProtocolDefinition;

  static const int unit = 432;
  static const int headerMark = 8 * unit;
  static const int headerSpace = 4 * unit;
  static const int bitMark = unit;
  static const int zeroSpace = unit;
  static const int oneSpace = 3 * unit;
  static const int repeatDistanceUs = 130000 - 56000;

  @override
  IrEncodeResult encode(Map<String, dynamic> params) {
    final List<int> addr =
        _read4Bytes(params, 'address', protocolName: 'Kaseikyo');
    final List<int> cmd =
        _read4Bytes(params, 'command', protocolName: 'Kaseikyo');

    final int b0 = addr[0] & 0xFF;
    final int genre1 = (b0 >> 4) & 0x0F;
    final int genre2 = b0 & 0x0F;

    final int vendorLsb = addr[1] & 0xFF;
    final int vendorMsb = addr[2] & 0xFF;

    // Command is carried little-endian in the first two command bytes.
    // The protocol uses 10 command bits. For Signal Tester brute force we also
    // use bits 10..11 as the 2-bit ID when the explicit address ID byte is 00.
    // This turns the finder's 6-hex input into 20 genuinely useful bits instead
    // of repeating each waveform 64 times and fixing ID to zero.
    final int command16 = ((cmd[1] & 0xFF) << 8) | (cmd[0] & 0xFF);
    final int command10 = command16 & 0x03FF;
    final int explicitId2 = addr[3] & 0x03;
    final int packedId2 = (command16 >> 10) & 0x03;
    final int id2 = explicitId2 != 0 ? explicitId2 : packedId2;

    int vendorParity = (vendorLsb ^ vendorMsb) & 0xFF;
    vendorParity = ((vendorParity & 0x0F) ^ (vendorParity >> 4)) & 0x0F;

    final int d0 = vendorLsb;
    final int d1 = vendorMsb;
    final int d2 = (vendorParity & 0x0F) | ((genre1 & 0x0F) << 4);
    final int d3 = (genre2 & 0x0F) | ((command10 & 0x0F) << 4);
    final int d4 = ((id2 & 0x03) << 6) | ((command10 >> 4) & 0x3F);
    final int d5 = (d2 ^ d3 ^ d4) & 0xFF;

    final List<int> bytesLsbFirst = <int>[d0, d1, d2, d3, d4, d5];
    final List<int> out = <int>[headerMark, headerSpace];

    for (final int b in bytesLsbFirst) {
      for (int i = 0; i < 8; i++) {
        final int bit = (b >> i) & 1;
        out.add(bitMark);
        out.add(bit == 0 ? zeroSpace : oneSpace);
      }
    }

    out.add(bitMark);
    out.add(repeatDistanceUs);

    return IrEncodeResult(
      frequencyHz: 37000,
      pattern: out,
    );
  }

  List<int> _read4Bytes(
    Map<String, dynamic> params,
    String key, {
    required String protocolName,
  }) {
    final dynamic v = params[key];
    if (v is! String) {
      throw ArgumentError('$protocolName: "$key" must be a 4-byte hex string');
    }
    final String s = v.trim();

    final List<String> parts;
    final RegExp spaced = RegExp(r'^([0-9A-Fa-f]{2}\s+){3}[0-9A-Fa-f]{2}$');
    final RegExp compact = RegExp(r'^[0-9A-Fa-f]{8}$');

    if (spaced.hasMatch(s)) {
      parts = s.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    } else if (compact.hasMatch(s)) {
      parts = <String>[
        s.substring(0, 2),
        s.substring(2, 4),
        s.substring(4, 6),
        s.substring(6, 8),
      ];
    } else {
      throw ArgumentError(
        '$protocolName: "$key" must be 4 bytes, e.g. "80 02 20 00" or "80022000"',
      );
    }

    if (parts.length != 4) {
      throw ArgumentError('$protocolName: "$key" must contain exactly 4 bytes');
    }

    return parts.map((p) => int.parse(p, radix: 16) & 0xFF).toList();
  }
}
