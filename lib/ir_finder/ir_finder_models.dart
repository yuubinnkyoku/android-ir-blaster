import 'dart:math';

import 'package:irblaster_controller/ir/ir_protocol_registry.dart';
import 'package:irblaster_controller/ir/ir_protocol_types.dart';

enum IrFinderMode { bruteforce, database }

enum IrFinderSource { bruteforce, database }

class IrFinderCandidate {
  final String protocolId;

  /// UI display fields expected by ir_finder_screen.dart
  final String displayProtocol;
  final String displayCode;

  /// Whatever your encoder expects.
  final dynamic params;

  final IrFinderSource source;

  /// Optional DB context expected by the screen
  final String? dbBrand;
  final String? dbModel;
  final String? dbLabel;
  final int? dbRemoteId;

  const IrFinderCandidate({
    required this.protocolId,
    required this.displayProtocol,
    required this.displayCode,
    required this.params,
    required this.source,
    this.dbBrand,
    this.dbModel,
    this.dbLabel,
    this.dbRemoteId,
  });

  /// Backward-compat aliases
  String get code => displayCode;
  String get protocolName => displayProtocol;
  String? get brand => dbBrand;
  String? get model => dbModel;
  String? get keyLabel => dbLabel;
  int? get dbId => dbRemoteId;
}

class IrFinderHit {
  final DateTime savedAt;

  final String protocolId;
  final String protocolName;
  final String code;

  final IrFinderSource source;

  /// Optional DB context expected by the screen
  final String? dbBrand;
  final String? dbModel;
  final String? dbLabel;
  final int? dbRemoteId;

  const IrFinderHit({
    required this.savedAt,
    required this.protocolId,
    required this.protocolName,
    required this.code,
    required this.source,
    this.dbBrand,
    this.dbModel,
    this.dbLabel,
    this.dbRemoteId,
  });

  /// Backward-compat aliases
  DateTime get foundAt => savedAt;
  String? get brand => dbBrand;
  String? get model => dbModel;
  String? get keyLabel => dbLabel;
  int? get dbId => dbRemoteId;
}

class IrDbKeyCandidate {
  final int id;

  /// Field names expected by ir_finder_screen.dart
  final String protocol;
  final String hexcode;
  final int? remoteId;
  final String? label;

  /// Optional context
  final String? brand;
  final String? model;

  const IrDbKeyCandidate({
    required this.id,
    required this.protocol,
    required this.hexcode,
    this.remoteId,
    this.label,
    this.brand,
    this.model,
  });

  /// Backward-compat aliases
  String get protocolId => protocol;
  String? get commandLabel => label;
  String? get deviceLabel => null;
}

class IrBigInt {
  static BigInt pow(BigInt base, int exp) {
    if (exp < 0) throw ArgumentError.value(exp, 'exp', 'Must be >= 0');
    BigInt result = BigInt.one;
    BigInt b = base;
    int e = exp;
    while (e > 0) {
      if ((e & 1) == 1) result *= b;
      e >>= 1;
      if (e > 0) b *= b;
    }
    return result;
  }

  static String formatHuman(BigInt n) {
    final BigInt thousand = BigInt.from(1000);
    if (n < thousand) return n.toString();
    const List<String> units = <String>['', 'K', 'M', 'B', 'T', 'P', 'E'];
    BigInt value = n;
    int u = 0;
    while (value >= thousand && u < units.length - 1) {
      value ~/= thousand;
      u++;
    }
    return '${value.toString()}${units[u]}';
  }

  static int toIntClamp(BigInt v, {required int max}) {
    if (v <= BigInt.zero) return 0;
    final BigInt m = BigInt.from(max);
    if (v >= m) return max;
    return v.toInt();
  }
}

/// Protocol-aware cursor canonicalization for brute-force scans.
///
/// Several encoders accept a nibble-aligned input even though some input bits
/// are masked, ignored, or derived. Iterating every raw input therefore sends
/// the same IR waveform many times. This helper advances only through one
/// canonical representative for each distinct payload while preserving the
/// existing code format shown by the Signal Tester.
///
/// Prefix-constrained scans deliberately do not use this cursor layer because
/// the screen cursor represents only the suffix in that mode. The run
/// controller falls back to the original sequential behavior when a prefix is
/// active.
class IrFinderBruteCursor {
  static BigInt _hex(String value) => BigInt.parse(value, radix: 16);

  static bool hasOptimization(String protocolId) {
    switch (protocolId.trim().toLowerCase()) {
      case 'denon':
      case 'kaseikyo':
      case 'rc5':
      case 'rcc0082':
      case 'rcc2026':
      case 'recs80':
      case 'recs80_l':
      case 'sharp':
      case 'sony15':
      case 'thomson7':
        return true;
      default:
        return false;
    }
  }

  /// First cursor value at which an unprefixed scan is exhausted.
  ///
  /// The sentinel intentionally stays in the original nominal input space so
  /// persisted cursors and the existing UI remain backward compatible.
  static BigInt? exhaustionCursor(String protocolId) {
    switch (protocolId.trim().toLowerCase()) {
      case 'denon':
      case 'rc5':
      case 'sharp':
      case 'sony15':
        return _hex('10000');
      case 'kaseikyo':
        return _hex('1000000');
      case 'rcc0082':
      case 'recs80':
      case 'recs80_l':
      case 'thomson7':
        return _hex('1000');
      case 'rcc2026':
        return _hex('100000000000'); // 16^11, the nominal 44-bit space
      default:
        return null;
    }
  }

  static bool isExhausted(String protocolId, BigInt cursor) {
    final BigInt? end = exhaustionCursor(protocolId);
    return end != null && cursor >= end;
  }

  /// Rounds [cursor] forward to the next canonical code for [protocolId].
  /// Never rounds backwards, except that values beyond a protocol's useful
  /// payload range are normalized to its exhaustion sentinel.
  static BigInt canonicalize(String protocolId, BigInt cursor) {
    final String id = protocolId.trim().toLowerCase();
    BigInt c = cursor < BigInt.zero ? BigInt.zero : cursor;

    switch (id) {
      case 'sharp':
        // 4 hex chars are accepted, but the encoder masks to 13 bits.
        return c <= _hex('1FFF') ? c : _hex('10000');

      case 'denon':
        // Only the low bit of the fourth nibble is transmitted. Canonical
        // representatives therefore end in 0 or 1.
        if (c >= _hex('10000')) return _hex('10000');
        final int lowNibble = (c & BigInt.from(0xF)).toInt();
        if (lowNibble <= 1) return c;
        final BigInt nextGroup = (c & ~BigInt.from(0xF)) + BigInt.from(0x10);
        return nextGroup < _hex('10000') ? nextGroup : _hex('10000');

      case 'rc5':
        // Finder format is AA CC, but RC5 has address=5 bits and command=6.
        if (c >= _hex('10000')) return _hex('10000');
        final int address = (c >> 8).toInt();
        final int command = (c & BigInt.from(0xFF)).toInt();
        if (address > 0x1F) return _hex('10000');
        if (command <= 0x3F) return c;
        final int nextAddress = address + 1;
        return nextAddress <= 0x1F
            ? BigInt.from(nextAddress << 8)
            : _hex('10000');

      case 'kaseikyo':
        // Finder format is GG CC HH. HH contains command bits 8..9 and ID
        // bits 0..1 after packing; its high nibble is otherwise ignored.
        if (c >= _hex('1000000')) return _hex('1000000');
        final int lastByte = (c & BigInt.from(0xFF)).toInt();
        if (lastByte <= 0x0F) return c;
        final BigInt nextGroup = (c & ~BigInt.from(0xFF)) + BigInt.from(0x100);
        return nextGroup < _hex('1000000') ? nextGroup : _hex('1000000');

      case 'rcc0082':
        // n0 uses 3 bits, n1 uses 4, n2 uses its top 2 bits: 9 free bits.
        // Canonical third nibbles are 0,4,8,C and canonical n0 is 0..7.
        if (c >= _hex('1000')) return _hex('1000');
        final BigInt rounded = (c + BigInt.from(3)) & ~BigInt.from(3);
        return rounded <= _hex('7FC') ? rounded : _hex('1000');

      case 'rcc2026':
        // 11 hex chars provide 44 bits but the encoder takes only the last 42.
        return c <= _hex('3FFFFFFFFFF') ? c : _hex('100000000000');

      case 'recs80':
      case 'recs80_l':
        // The third nibble contributes only its most significant bit.
        if (c >= _hex('1000')) return _hex('1000');
        final int lowNibble = (c & BigInt.from(0xF)).toInt();
        if (lowNibble == 0 || lowNibble == 8) return c;
        if (lowNibble < 8) {
          return (c & ~BigInt.from(0xF)) + BigInt.from(8);
        }
        final BigInt nextGroup = (c & ~BigInt.from(0xF)) + BigInt.from(0x10);
        return nextGroup < _hex('1000') ? nextGroup : _hex('1000');

      case 'sony15':
        // Packed Sony15 is exactly 15 bits in a 4-hex-digit container.
        return c <= _hex('7FFF') ? c : _hex('10000');

      case 'thomson7':
        // Encoder masks bit 7 (0x080), so keep only 00..7F in every 0x100
        // block and skip 80..FF.
        if (c >= _hex('1000')) return _hex('1000');
        if ((c & BigInt.from(0x80)) == BigInt.zero) return c;
        final BigInt nextBlock = (c & ~BigInt.from(0xFF)) + BigInt.from(0x100);
        return nextBlock < _hex('1000') ? nextBlock : _hex('1000');

      default:
        return c;
    }
  }

  static BigInt next(String protocolId, BigInt cursor) {
    if (isExhausted(protocolId, cursor)) {
      return exhaustionCursor(protocolId) ?? cursor;
    }
    return canonicalize(protocolId, cursor + BigInt.one);
  }
}

class IrFinderBruteSpec {
  final String protocolId;

  /// Number of hex digits used by the Signal Tester input format.
  final int totalHexDigits;

  /// Number of genuinely independent payload bits after masks/check fields.
  final int uniqueBits;

  /// UI name.
  final String displayName;

  const IrFinderBruteSpec({
    required this.protocolId,
    required this.totalHexDigits,
    required this.uniqueBits,
    required this.displayName,
  });

  BigInt get uniqueCandidateCount => BigInt.one << uniqueBits;

  static IrFinderBruteSpec? forProtocol(String protocolId) {
    final String id = protocolId.trim().toLowerCase();
    switch (id) {
      case 'denon':
        return const IrFinderBruteSpec(
          protocolId: 'denon', totalHexDigits: 4, uniqueBits: 13, displayName: 'Denon');
      case 'f12_relaxed':
        return const IrFinderBruteSpec(
          protocolId: 'f12_relaxed', totalHexDigits: 3, uniqueBits: 12, displayName: 'F12_relaxed');
      case 'jvc':
        return const IrFinderBruteSpec(
          protocolId: 'jvc', totalHexDigits: 4, uniqueBits: 16, displayName: 'JVC');
      case 'kaseikyo':
        return const IrFinderBruteSpec(
          protocolId: 'kaseikyo', totalHexDigits: 6, uniqueBits: 20, displayName: 'Kaseikyo');
      case 'nec':
      case 'nec2':
      case 'necx1':
      case 'necx2':
        return IrFinderBruteSpec(
          protocolId: id, totalHexDigits: 8, uniqueBits: 32, displayName: id.toUpperCase());
      case 'nrc17':
        return const IrFinderBruteSpec(
          protocolId: 'nrc17', totalHexDigits: 4, uniqueBits: 16, displayName: 'Nokia NRC17');
      case 'pioneer':
        return const IrFinderBruteSpec(
          protocolId: 'pioneer', totalHexDigits: 4, uniqueBits: 16, displayName: 'Pioneer');
      case 'proton':
        return const IrFinderBruteSpec(
          protocolId: 'proton', totalHexDigits: 4, uniqueBits: 16, displayName: 'Proton');
      case 'rc5':
        return const IrFinderBruteSpec(
          protocolId: 'rc5', totalHexDigits: 4, uniqueBits: 11, displayName: 'RC5');
      case 'rc6':
        return const IrFinderBruteSpec(
          protocolId: 'rc6', totalHexDigits: 4, uniqueBits: 16, displayName: 'RC6');
      case 'rca_38':
        return const IrFinderBruteSpec(
          protocolId: 'rca_38', totalHexDigits: 3, uniqueBits: 12, displayName: 'RCA_38');
      case 'rcc0082':
        return const IrFinderBruteSpec(
          protocolId: 'rcc0082', totalHexDigits: 3, uniqueBits: 9, displayName: 'RCC0082');
      case 'rcc2026':
        return const IrFinderBruteSpec(
          protocolId: 'rcc2026', totalHexDigits: 11, uniqueBits: 42, displayName: 'RCC2026');
      case 'rec80':
        return const IrFinderBruteSpec(
          protocolId: 'rec80', totalHexDigits: 12, uniqueBits: 48, displayName: 'REC80');
      case 'recs80':
        return const IrFinderBruteSpec(
          protocolId: 'recs80', totalHexDigits: 3, uniqueBits: 9, displayName: 'RECS80');
      case 'recs80_l':
        return const IrFinderBruteSpec(
          protocolId: 'recs80_l', totalHexDigits: 3, uniqueBits: 9, displayName: 'RECS80_L');
      case 'samsung32':
        return const IrFinderBruteSpec(
          protocolId: 'samsung32', totalHexDigits: 4, uniqueBits: 16, displayName: 'Samsung32');
      case 'samsung36':
        return const IrFinderBruteSpec(
          protocolId: 'samsung36', totalHexDigits: 7, uniqueBits: 28, displayName: 'Samsung36');
      case 'sharp':
        return const IrFinderBruteSpec(
          protocolId: 'sharp', totalHexDigits: 4, uniqueBits: 13, displayName: 'Sharp');
      case 'sony12':
        return const IrFinderBruteSpec(
          protocolId: 'sony12', totalHexDigits: 3, uniqueBits: 12, displayName: 'SONY12');
      case 'sony15':
        return const IrFinderBruteSpec(
          protocolId: 'sony15', totalHexDigits: 4, uniqueBits: 15, displayName: 'SONY15');
      case 'sony20':
        return const IrFinderBruteSpec(
          protocolId: 'sony20', totalHexDigits: 5, uniqueBits: 20, displayName: 'SONY20');
      case 'thomson7':
        return const IrFinderBruteSpec(
          protocolId: 'thomson7', totalHexDigits: 3, uniqueBits: 11, displayName: 'Thomson7');
      case 'xsat':
        return const IrFinderBruteSpec(
          protocolId: 'xsat', totalHexDigits: 4, uniqueBits: 16, displayName: 'XSAT (Mitsubishi)');
      default:
        return null;
    }
  }

  /// Legacy helper (kept permissive).
  static String composeHex({
    IrFinderBruteSpec? spec,
    String? protocolId,
    int? totalHexDigits,
    BigInt? cursor,
    BigInt? counter,
    BigInt? attempt,
    BigInt? index,
    BigInt? value,
    List<int>? prefixBytes,
    String? prefixHex,
    Object? prefix,
    Object? prefixConstraint,
  }) {
    final int digits = max(1, totalHexDigits ?? spec?.totalHexDigits ?? 8);
    BigInt c = cursor ?? counter ?? attempt ?? index ?? value ?? BigInt.zero;
    if (c.isNegative) c = BigInt.zero;

    List<int> bytes = <int>[];
    final Object? p = prefixBytes ?? prefixHex ?? prefix ?? prefixConstraint;
    if (p is List<int>) {
      bytes = List<int>.from(p);
    } else if (p is String) {
      final String cleaned = p.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
      if (cleaned.length.isEven && cleaned.isNotEmpty) {
        bytes = <int>[
          for (int i = 0; i < cleaned.length; i += 2)
            int.parse(cleaned.substring(i, i + 2), radix: 16),
        ];
      }
    } else {
      try {
        final dynamic d = p;
        if (d != null && d.valid == true && d.bytes is List<int>) {
          bytes = List<int>.from(d.bytes as List<int>);
        }
      } catch (_) {}
    }

    final String prefixStr = bytes
        .map((int b) => b.clamp(0, 255).toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();

    final int usedDigits = min(prefixStr.length, digits);
    final int remaining = digits - usedDigits;

    final BigInt space =
        remaining <= 0 ? BigInt.one : IrBigInt.pow(BigInt.from(16), remaining);
    final BigInt normalized = remaining <= 0 ? BigInt.zero : (c % space);

    final String tail = remaining <= 0
        ? ''
        : normalized.toRadixString(16).padLeft(remaining, '0').toUpperCase();

    return (prefixStr.substring(0, usedDigits) + tail)
        .padRight(digits, '0')
        .toUpperCase();
  }
}

class IrFinderParams {
  static String _cleanHex(String s) =>
      s.replaceAll(RegExp(r'[^0-9a-fA-F]'), '').toUpperCase();

  static String _pickPrimaryFieldId(IrProtocolDefinition def) {
    final fields = def.fields;

    String? findById(Set<String> ids) {
      for (final f in fields) {
        final id = f.id.trim().toLowerCase();
        if (ids.contains(id)) return f.id;
      }
      return null;
    }

    final String? direct = findById(<String>{
      'hex',
      'code',
      'hexcode',
      'data',
      'value',
      'command',
      'payload',
    });
    if (direct != null) return direct;

    for (final f in fields) {
      if (f.type == IrFieldType.string) return f.id;
    }

    if (fields.isNotEmpty) return fields.first.id;

    return 'hex';
  }

  static Map<String, dynamic> buildParamsForProtocol(
    String protocolId,
    String codeHex, {
    String? kaseikyoVendor,
  }) {
    final String id = protocolId.trim().toLowerCase();
    final String cleaned = _cleanHex(codeHex).toUpperCase();

    // Special handling retained for legacy callers. The Signal Tester screen
    // has its own Kaseikyo packing helper.
    if (id == 'kaseikyo') {
      final String six = cleaned
          .padLeft(6, '0')
          .substring(cleaned.length > 6 ? cleaned.length - 6 : 0);
      final String addr = six.substring(0, 3);
      final String cmd = six.substring(3, 5);
      final String vendor =
          (kaseikyoVendor != null && kaseikyoVendor.trim().isNotEmpty)
              ? kaseikyoVendor.trim().toUpperCase()
              : '2002';
      return <String, dynamic>{
        'protocolId': 'kaseikyo',
        'vendor': vendor,
        'address': addr,
        'command': cmd,
      };
    }

    final enc = IrProtocolRegistry.encoderFor(protocolId);
    final def = enc.definition;

    final String key = _pickPrimaryFieldId(def);

    return <String, dynamic>{
      'protocolId': protocolId,
      key: cleaned,
    };
  }
}
