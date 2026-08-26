import 'package:flutter/material.dart';

@immutable
final class WattFlowColors extends ThemeExtension<WattFlowColors> {
  const WattFlowColors({
    required this.online,
    required this.offline,
    required this.energyAccent,
  });

  final Color online;
  final Color offline;
  final Color energyAccent;

  static const light = WattFlowColors(
    online: Color(0xFF197A4A),
    offline: Color(0xFF667085),
    energyAccent: Color(0xFF146B5B),
  );

  static const dark = WattFlowColors(
    online: Color(0xFF62D994),
    offline: Color(0xFFB5BBC7),
    energyAccent: Color(0xFF7ADFCB),
  );

  @override
  WattFlowColors copyWith({
    Color? online,
    Color? offline,
    Color? energyAccent,
  }) => WattFlowColors(
    online: online ?? this.online,
    offline: offline ?? this.offline,
    energyAccent: energyAccent ?? this.energyAccent,
  );

  @override
  WattFlowColors lerp(covariant WattFlowColors? other, double t) {
    if (other == null) return this;
    return WattFlowColors(
      online: Color.lerp(online, other.online, t)!,
      offline: Color.lerp(offline, other.offline, t)!,
      energyAccent: Color.lerp(energyAccent, other.energyAccent, t)!,
    );
  }
}
