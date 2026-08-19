import 'package:flutter_test/flutter_test.dart';
import 'package:irblaster_controller/ir/protocols/sharp.dart';
import 'package:irblaster_controller/ir/protocols/sharp_scan.dart';
import 'package:irblaster_controller/ir_finder/ir_finder_models.dart';

void main() {
  test('Sharp low-bank scanner matches base Sharp 0000-0FFF codes', () {
    final scan = const SharpScanLowProtocolEncoder().encode(
      <String, dynamic>{'hex': 'ABC'},
    );
    final base = const SharpProtocolEncoder().encode(
      <String, dynamic>{'hex': '0ABC'},
    );

    expect(scan.frequencyHz, base.frequencyHz);
    expect(scan.pattern, base.pattern);
  });

  test('Sharp high-bank scanner matches base Sharp 1000-1FFF codes', () {
    final scan = const SharpScanHighProtocolEncoder().encode(
      <String, dynamic>{'hex': 'ABC'},
    );
    final base = const SharpProtocolEncoder().encode(
      <String, dynamic>{'hex': '1ABC'},
    );

    expect(scan.frequencyHz, base.frequencyHz);
    expect(scan.pattern, base.pattern);
  });

  test('Sharp scan protocols expose 4096 brute-force candidates per bank', () {
    final low = IrFinderBruteSpec.forProtocol('sharp_scan_low');
    final high = IrFinderBruteSpec.forProtocol('sharp_scan_high');

    expect(low?.totalHexDigits, 3);
    expect(high?.totalHexDigits, 3);
    expect(IrBigInt.pow(BigInt.from(16), low!.totalHexDigits), BigInt.from(4096));
    expect(IrBigInt.pow(BigInt.from(16), high!.totalHexDigits), BigInt.from(4096));
  });

  test('Sharp scan protocols reject non-3-digit codes', () {
    expect(
      () => const SharpScanLowProtocolEncoder().encode(
        <String, dynamic>{'hex': '12'},
      ),
      throwsFormatException,
    );
    expect(
      () => const SharpScanHighProtocolEncoder().encode(
        <String, dynamic>{'hex': '1234'},
      ),
      throwsFormatException,
    );
  });
}
