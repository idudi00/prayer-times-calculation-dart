import 'calculation_method.dart';
import 'asr_jurisdiction.dart';

/// Configuration options for prayer time calculations
class CalculationOptions {
  /// Creates a new CalculationOptions instance
  const CalculationOptions({
    required this.method,
    required this.asrJurisdiction,
    this.fajrAngle,
    this.ishaAngle,
  });

  /// The calculation method to use
  final CalculationMethod method;

  /// The Asr calculation jurisdiction
  final AsrJurisdiction asrJurisdiction;

  /// Custom fajr angle (required when method is custom)
  final double? fajrAngle;

  /// Custom isha angle (required when method is custom)
  final double? ishaAngle;

  /// Validates the calculation options
  void validate() {
    if (method == CalculationMethod.custom) {
      if (fajrAngle == null || ishaAngle == null) {
        throw ArgumentError(
          'Custom method requires both fajrAngle and ishaAngle to be specified',
        );
      }
    }
  }

  @override
  String toString() {
    return 'CalculationOptions('
        'method: ${method.key}, '
        'asrJurisdiction: ${asrJurisdiction.key}, '
        'fajrAngle: $fajrAngle, '
        'ishaAngle: $ishaAngle'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalculationOptions &&
        other.method == method &&
        other.asrJurisdiction == asrJurisdiction &&
        other.fajrAngle == fajrAngle &&
        other.ishaAngle == ishaAngle;
  }

  @override
  int get hashCode {
    return method.hashCode ^
        asrJurisdiction.hashCode ^
        fajrAngle.hashCode ^
        ishaAngle.hashCode;
  }

  /// Creates a copy of this CalculationOptions with the given fields replaced
  CalculationOptions copyWith({
    CalculationMethod? method,
    AsrJurisdiction? asrJurisdiction,
    double? fajrAngle,
    double? ishaAngle,
  }) {
    return CalculationOptions(
      method: method ?? this.method,
      asrJurisdiction: asrJurisdiction ?? this.asrJurisdiction,
      fajrAngle: fajrAngle ?? this.fajrAngle,
      ishaAngle: ishaAngle ?? this.ishaAngle,
    );
  }
}
