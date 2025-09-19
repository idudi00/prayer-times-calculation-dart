/// Supported prayer time calculation methods
enum CalculationMethod {
  /// Muslim World League
  mwl,

  /// Islamic Society of North America
  isna,

  /// Egyptian General Authority of Survey
  egypt,

  /// Umm Al-Qura University, Makkah
  makkah,

  /// University of Islamic Sciences, Karachi
  karachi,

  /// Custom angles specified by user
  custom,
}

/// Extension to provide string representations for calculation methods
extension CalculationMethodExtension on CalculationMethod {
  /// Returns the display name for the calculation method
  String get displayName {
    switch (this) {
      case CalculationMethod.mwl:
        return 'Muslim World League';
      case CalculationMethod.isna:
        return 'Islamic Society of North America';
      case CalculationMethod.egypt:
        return 'Egyptian General Authority';
      case CalculationMethod.makkah:
        return 'Umm Al-Qura University';
      case CalculationMethod.karachi:
        return 'University of Islamic Sciences, Karachi';
      case CalculationMethod.custom:
        return 'Custom';
    }
  }

  /// Returns the string key for the calculation method
  String get key {
    switch (this) {
      case CalculationMethod.mwl:
        return 'MWL';
      case CalculationMethod.isna:
        return 'ISNA';
      case CalculationMethod.egypt:
        return 'Egypt';
      case CalculationMethod.makkah:
        return 'Makkah';
      case CalculationMethod.karachi:
        return 'Karachi';
      case CalculationMethod.custom:
        return 'Custom';
    }
  }
}