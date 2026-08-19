import '../ir_protocol_types.dart';
import 'sharp.dart';

const IrProtocolDefinition sharpScanLowProtocolDefinition = IrProtocolDefinition(
  id: 'sharp_scan_low',
  displayName: 'Sharp scan 0000-0FFF',
  description:
      'Sharp 13-bit brute-force helper for the lower 12-bit bank. '
      'Input 000-FFF is transmitted as Sharp code 0000-0FFF. '
      'Run this together with the upper-bank scanner to cover all 8192 unique Sharp codes without duplicates.',
  implemented: true,
  defaultFrequencyHz: 38000,
  fields: <IrFieldDef>[
    IrFieldDef(
      id: 'hex',
      label: 'Hex (3 chars)',
      type: IrFieldType.string,
      required: true,
      helperText: 'Exactly 3 hex characters (000-FFF).',
      maxLength: 3,
      maxLines: 1,
    ),
  ],
);

const IrProtocolDefinition sharpScanHighProtocolDefinition = IrProtocolDefinition(
  id: 'sharp_scan_high',
  displayName: 'Sharp scan 1000-1FFF',
  description:
      'Sharp 13-bit brute-force helper for the upper 12-bit bank. '
      'Input 000-FFF is transmitted as Sharp code 1000-1FFF. '
      'Run this together with the lower-bank scanner to cover all 8192 unique Sharp codes without duplicates.',
  implemented: true,
  defaultFrequencyHz: 38000,
  fields: <IrFieldDef>[
    IrFieldDef(
      id: 'hex',
      label: 'Hex (3 chars)',
      type: IrFieldType.string,
      required: true,
      helperText: 'Exactly 3 hex characters (000-FFF).',
      maxLength: 3,
      maxLines: 1,
    ),
  ],
);

class SharpScanLowProtocolEncoder implements IrProtocolEncoder {
  static const String protocolId = 'sharp_scan_low';
  const SharpScanLowProtocolEncoder();

  @override
  String get id => protocolId;

  @override
  IrProtocolDefinition get definition => sharpScanLowProtocolDefinition;

  @override
  IrEncodeResult encode(Map<String, dynamic> params) {
    return const SharpProtocolEncoder().encode(<String, dynamic>{
      'hex': _expandSharpScanHex(params['hex'], highBank: false),
    });
  }
}

class SharpScanHighProtocolEncoder implements IrProtocolEncoder {
  static const String protocolId = 'sharp_scan_high';
  const SharpScanHighProtocolEncoder();

  @override
  String get id => protocolId;

  @override
  IrProtocolDefinition get definition => sharpScanHighProtocolDefinition;

  @override
  IrEncodeResult encode(Map<String, dynamic> params) {
    return const SharpProtocolEncoder().encode(<String, dynamic>{
      'hex': _expandSharpScanHex(params['hex'], highBank: true),
    });
  }
}

String _expandSharpScanHex(dynamic raw, {required bool highBank}) {
  if (raw is! String) {
    throw ArgumentError('hex must be a String');
  }

  final String hex = raw.trim();
  if (!RegExp(r'^[0-9A-Fa-f]{3}$').hasMatch(hex)) {
    throw FormatException('Sharp scan code must be exactly 3 hex characters');
  }

  final int low12 = int.parse(hex, radix: 16) & 0x0FFF;
  final int full13 = (highBank ? 0x1000 : 0x0000) | low12;
  return full13.toRadixString(16).padLeft(4, '0').toUpperCase();
}
