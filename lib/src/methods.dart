import 'models/calculation_method.dart';
import 'models/method_angles.dart';

/// Predefined calculation methods with their respective angles
class CalculationMethods {
  /// Map of calculation methods to their angles
  static const Map<CalculationMethod, MethodAngles?> _methods = {
    CalculationMethod.mwl: MethodAngles(fajr: 18.0, isha: 17.0),
    CalculationMethod.isna: MethodAngles(fajr: 15.0, isha: 15.0),
    CalculationMethod.egypt: MethodAngles(fajr: 19.5, isha: 17.5),
    CalculationMethod.makkah: MethodAngles(fajr: 18.5, isha: 18.5),
    CalculationMethod.karachi: MethodAngles(fajr: 18.0, isha: 18.0),
    CalculationMethod.custom: null,
  };

  /// Get method angles for a specific calculation method
  static MethodAngles getMethodAngles(
    CalculationMethod method, {
    double? customFajr,
    double? customIsha,
  }) {
    if (method == CalculationMethod.custom) {
      if (customFajr == null || customIsha == null) {
        throw ArgumentError(
          'Custom method requires both fajrAngle and ishaAngle to be specified',
        );
      }
      return MethodAngles(fajr: customFajr, isha: customIsha);
    }

    final angles = _methods[method];
    if (angles == null) {
      throw ArgumentError('Invalid calculation method: ${method.key}');
    }

    return angles;
  }

  /// Get all available calculation methods
  static List<CalculationMethod> get allMethods => _methods.keys.toList();

  /// Check if a method has predefined angles
  static bool hasPredefineAngles(CalculationMethod method) {
    return _methods[method] != null;
  }

  /// Get method description
  static String getMethodDescription(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.mwl:
        return 'Muslim World League (Fajr: 18°, Isha: 17°)';
      case CalculationMethod.isna:
        return 'Islamic Society of North America (Fajr: 15°, Isha: 15°)';
      case CalculationMethod.egypt:
        return 'Egyptian General Authority (Fajr: 19.5°, Isha: 17.5°)';
      case CalculationMethod.makkah:
        return 'Umm Al-Qura University (Fajr: 18.5°, Isha: 18.5°)';
      case CalculationMethod.karachi:
        return 'University of Islamic Sciences, Karachi (Fajr: 18°, Isha: 18°)';
      case CalculationMethod.custom:
        return 'Custom angles specified by user';
    }
  }
}
