import '../ir_protocol_types.dart';

const IrProtocolDefinition sony20ProtocolDefinition = IrProtocolDefinition(
  id: 'sony20',
  displayName: 'SONY20',
  description:
      'Sony SIRC 20-bit. Packed hex is the exact 20-bit transmitted payload: '
      'command(7 LSB) + address(13) << 7. Legacy address+command params are also accepted. '
      'Bit order: LSB-first. Timings: 2400/600 header, 0=600/600, 1=1200/600.',
  implemented: true,
  defaultFrequencyHz: 40000,
  fields: <IrFieldDef>[
    IrFieldDef(
      id: 'hex',
      label: 'Packed code (20-bit)',
      type: IrFieldType.string,
      required: true,
      maxLength: 5,
      hint: 'e.g., D5E2F',
      helperText: 'Exact 20-bit SIRC payload (00000..FFFFF).',
      maxLines: 1,
    ),
  ],
);

class Sony20ProtocolEncoder implements IrProtocolEncoder {
  static const String protocolId = 'sony20';
  const Sony20ProtocolEncoder();

  @override
  String get id => protocolId;

  @override
  IrProtocolDefinition get definition => sony20ProtocolDefinition;

  static const int carrierHz = 40000;
  static const int hdrMark = 2400;
  static const int hdrSpace = 600;
  static const int oneMark = 1200;
  static const int zeroMark = 600;
  static const int space = 600;
  static const int frameTotalUs = 45000;

  @override
  IrEncodeResult encode(Map<String, dynamic> params) {
    final int data = _readSony20Payload(params);
    const int bits = 20;

    List<int> oneFrame() {
      final List<int> seq = <int>[hdrMark, hdrSpace];
      for (int i = 0; i < bits; i++) {
        final int bit = (data >> i) & 1;
        seq.add(bit == 1 ? oneMark : zeroMark);
        seq.add(space);
      }
      if (seq.isNotEmpty) seq.removeLast();
      final int used = _sum(seq);
      final int remaining = frameTotalUs - used;
      seq.add(remaining > 0 ? remaining : 0);
      return seq;
    }

    final List<int> frame = oneFrame();
    return IrEncodeResult(
      frequencyHz: carrierHz,
      pattern: <int>[...frame, ...frame, ...frame],
    );
  }
}

int _readSony20Payload(Map<String, dynamic> params) {
  final dynamic packed = params['hex'];
  if (packed != null) {
    if (packed is! String) throw ArgumentError('SONY20 hex must be a string');
    final String s = packed.trim();
    if (!RegExp(r'^[0-9A-Fa-f]{1,5}$').hasMatch(s)) {
      throw ArgumentError('SONY20 hex must be 1..5 hex digits');
    }
    return int.parse(s, radix: 16) & 0xFFFFF;
  }

  final int addr = _readHexInt(params['address'], name: 'SONY20 address') & 0x1FFF;
  final int cmd = _readHexInt(params['command'], name: 'SONY20 command') & 0x7F;
  return (cmd & 0x7F) | ((addr & 0x1FFF) << 7);
}

int _readHexInt(dynamic v, {required String name}) {
  if (v is! String) throw ArgumentError('$name must be a hex string');
  final String s = v.trim();
  if (s.isEmpty || s.length > 8) throw ArgumentError('$name invalid hex');
  return int.parse(s, radix: 16);
}

int _sum(List<int> xs) {
  int s = 0;
  for (final int v in xs) {
    s += v;
  }
  return s;
}
