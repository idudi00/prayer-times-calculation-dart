/// Represents the fajr and isha angles for a calculation method
class MethodAngles {
  /// Creates a new MethodAngles instance
  const MethodAngles({
    required this.fajr,
    required this.isha,
  });

  /// The fajr angle in degrees
  final double fajr;

  /// The isha angle in degrees
  final double isha;

  @override
  String toString() => 'MethodAngles(fajr: $fajr, isha: $isha)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MethodAngles &&
        other.fajr == fajr &&
        other.isha == isha;
  }

  @override
  int get hashCode => fajr.hashCode ^ isha.hashCode;

  /// Creates a copy of this MethodAngles with the given fields replaced
  MethodAngles copyWith({
    double? fajr,
    double? isha,
  }) {
    return MethodAngles(
      fajr: fajr ?? this.fajr,
      isha: isha ?? this.isha,
    );
  }
}