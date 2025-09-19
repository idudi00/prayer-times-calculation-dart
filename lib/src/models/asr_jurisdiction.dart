/// Asr calculation methods based on Islamic jurisprudence
enum AsrJurisdiction {
  /// Standard method (Shafi, Maliki, Hanbali schools)
  /// Shadow length = object height
  standard,

  /// Hanafi school method
  /// Shadow length = 2 × object height
  hanafi,
}

/// Extension to provide string representations for Asr jurisdictions
extension AsrJurisdictionExtension on AsrJurisdiction {
  /// Returns the display name for the Asr jurisdiction
  String get displayName {
    switch (this) {
      case AsrJurisdiction.standard:
        return 'Standard (Shafi/Maliki/Hanbali)';
      case AsrJurisdiction.hanafi:
        return 'Hanafi';
    }
  }

  /// Returns the string key for the Asr jurisdiction
  String get key {
    switch (this) {
      case AsrJurisdiction.standard:
        return 'Standard';
      case AsrJurisdiction.hanafi:
        return 'Hanafi';
    }
  }

  /// Returns the shadow factor for the jurisdiction
  int get shadowFactor {
    switch (this) {
      case AsrJurisdiction.standard:
        return 1;
      case AsrJurisdiction.hanafi:
        return 2;
    }
  }
}