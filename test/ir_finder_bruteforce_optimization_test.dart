import 'package:flutter_test/flutter_test.dart';
import 'package:irblaster_controller/ir/protocols/kaseikyo.dart';
import 'package:irblaster_controller/ir/protocols/sony12.dart';
import 'package:irblaster_controller/ir/protocols/sony15.dart';
import 'package:irblaster_controller/ir/protocols/sony20.dart';
import 'package:irblaster_controller/ir_finder/ir_finder_models.dart';

void main() {
  group('protocol-aware brute-force space', () {
    final expectedBits = <String, int>{
      'denon': 13,
      'f12_relaxed': 12,
      'jvc': 16,
      'kaseikyo': 20,
      'nec': 32,
      'nec2': 32,
      'necx1': 32,
      'necx2': 32,
      'nrc17': 16,
      'pioneer': 16,
      'proton': 16,
      'rc5': 11,
      'rc6': 16,
      'rca_38': 12,
      'rcc0082': 9,
      'rcc2026': 42,
      'rec80': 48,
      'recs80': 9,
      'recs80_l': 9,
      'samsung32': 16,
      'samsung36': 28,
      'sharp': 13,
      'sony12': 12,
      'sony15': 15,
      'sony20': 20,
      'thomson7': 11,
      'xsat': 16,
    };

    for (final entry in expectedBits.entries) {
      test('${entry.key} exposes its true number of free bits', () {
        final spec = IrFinderBruteSpec.forProtocol(entry.key);
        expect(spec, isNotNull);
        expect(spec!.uniqueBits, entry.value);
        expect(spec.uniqueCandidateCount, BigInt.one << entry.value);
      });
    }
  });

  group('duplicate-free cursor canonicalization', () {
    BigInt h(String value) => BigInt.parse(value, radix: 16);

    test('Sharp scans each 13-bit code once', () {
      expect(IrFinderBruteCursor.canonicalize('sharp', h('1FFF')), h('1FFF'));
      expect(IrFinderBruteCursor.next('sharp', h('1FFF')), h('10000'));
      expect(IrFinderBruteCursor.isExhausted('sharp', h('10000')), isTrue);
    });

    test('Denon keeps only final nibble 0/1', () {
      expect(IrFinderBruteCursor.next('denon', h('0000')), h('0001'));
      expect(IrFinderBruteCursor.next('denon', h('0001')), h('0010'));
      expect(IrFinderBruteCursor.canonicalize('denon', h('000A')), h('0010'));
      expect(IrFinderBruteCursor.next('denon', h('FFF1')), h('10000'));
    });

    test('RC5 keeps address 00..1F and command 00..3F', () {
      expect(IrFinderBruteCursor.next('rc5', h('003F')), h('0100'));
      expect(IrFinderBruteCursor.canonicalize('rc5', h('00FE')), h('0100'));
      expect(IrFinderBruteCursor.next('rc5', h('1F3F')), h('10000'));
    });

    test('Kaseikyo uses only low nibble of packed high command byte', () {
      expect(IrFinderBruteCursor.next('kaseikyo', h('00000F')), h('000100'));
      expect(IrFinderBruteCursor.canonicalize('kaseikyo', h('0000A0')), h('000100'));
      expect(IrFinderBruteCursor.next('kaseikyo', h('FFFF0F')), h('1000000'));
    });

    test('RCC0082 keeps exactly its 9 free input bits', () {
      expect(IrFinderBruteCursor.next('rcc0082', h('000')), h('004'));
      expect(IrFinderBruteCursor.next('rcc0082', h('004')), h('008'));
      expect(IrFinderBruteCursor.next('rcc0082', h('008')), h('00C'));
      expect(IrFinderBruteCursor.next('rcc0082', h('00C')), h('010'));
      expect(IrFinderBruteCursor.canonicalize('rcc0082', h('00E')), h('010'));
      expect(IrFinderBruteCursor.next('rcc0082', h('7FC')), h('1000'));
    });

    test('RCC2026 skips the two ignored top bits', () {
      expect(
        IrFinderBruteCursor.next('rcc2026', h('3FFFFFFFFFF')),
        h('100000000000'),
      );
    });

    test('RECS80 variants keep only 0/8 in the third nibble', () {
      for (final id in <String>['recs80', 'recs80_l']) {
        expect(IrFinderBruteCursor.next(id, h('000')), h('008'));
        expect(IrFinderBruteCursor.next(id, h('008')), h('010'));
        expect(IrFinderBruteCursor.canonicalize(id, h('00D')), h('010'));
        expect(IrFinderBruteCursor.next(id, h('FF8')), h('1000'));
      }
    });

    test('Sony15 scans only 15 useful bits', () {
      expect(IrFinderBruteCursor.next('sony15', h('7FFF')), h('10000'));
    });

    test('Thomson7 skips the bit masked by 0xF7F', () {
      expect(IrFinderBruteCursor.next('thomson7', h('07F')), h('100'));
      expect(IrFinderBruteCursor.canonicalize('thomson7', h('0A0')), h('100'));
      expect(IrFinderBruteCursor.next('thomson7', h('F7F')), h('1000'));
    });
  });

  group('packed finder payloads remain encoder-compatible', () {
    test('Sony12 packed code matches legacy address+command', () {
      final packed = const Sony12ProtocolEncoder().encode(
        <String, dynamic>{'hex': 'D15'},
      );
      final legacy = const Sony12ProtocolEncoder().encode(
        <String, dynamic>{'address': '1A', 'command': '15'},
      );
      expect(packed.frequencyHz, legacy.frequencyHz);
      expect(packed.pattern, legacy.pattern);
    });

    test('Sony15 packed code matches legacy address+command', () {
      final packed = const Sony15ProtocolEncoder().encode(
        <String, dynamic>{'hex': '4015'},
      );
      final legacy = const Sony15ProtocolEncoder().encode(
        <String, dynamic>{'address': '80', 'command': '15'},
      );
      expect(packed.frequencyHz, legacy.frequencyHz);
      expect(packed.pattern, legacy.pattern);
    });

    test('Sony20 packed code matches legacy address+command', () {
      final packed = const Sony20ProtocolEncoder().encode(
        <String, dynamic>{'hex': 'D5E2F'},
      );
      final legacy = const Sony20ProtocolEncoder().encode(
        <String, dynamic>{'address': '1ABC', 'command': '2F'},
      );
      expect(packed.frequencyHz, legacy.frequencyHz);
      expect(packed.pattern, legacy.pattern);
    });

    test('Kaseikyo finder packs ID into command bits 10..11', () {
      final explicit = const KaseikyoProtocolEncoder().encode(
        <String, dynamic>{
          'address': '12 AA 5A 02',
          'command': '55 01 00 00',
        },
      );
      final packed = const KaseikyoProtocolEncoder().encode(
        <String, dynamic>{
          'address': '12 AA 5A 00',
          'command': '55 09 00 00',
        },
      );
      expect(packed.frequencyHz, explicit.frequencyHz);
      expect(packed.pattern, explicit.pattern);
    });
  });
}
