/// Represents the five daily prayer times
class PrayerTimes {
  /// Creates a new PrayerTimes instance
  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  /// Dawn prayer time (formatted as HH:mm)
  final String fajr;

  /// Sunrise time (formatted as HH:mm)
  final String sunrise;

  /// Noon prayer time (formatted as HH:mm)
  final String dhuhr;

  /// Afternoon prayer time (formatted as HH:mm)
  final String asr;

  /// Sunset prayer time (formatted as HH:mm)
  final String maghrib;

  /// Night prayer time (formatted as HH:mm)
  final String isha;

  /// Returns a list of all prayer times in order
  List<String> get allTimes => [fajr, sunrise, dhuhr, asr, maghrib, isha];

  /// Returns a map of prayer names to times
  Map<String, String> toMap() => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  @override
  String toString() {
    return 'PrayerTimes('
        'fajr: $fajr, '
        'sunrise: $sunrise, '
        'dhuhr: $dhuhr, '
        'asr: $asr, '
        'maghrib: $maghrib, '
        'isha: $isha'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerTimes &&
        other.fajr == fajr &&
        other.sunrise == sunrise &&
        other.dhuhr == dhuhr &&
        other.asr == asr &&
        other.maghrib == maghrib &&
        other.isha == isha;
  }

  @override
  int get hashCode {
    return fajr.hashCode ^
        sunrise.hashCode ^
        dhuhr.hashCode ^
        asr.hashCode ^
        maghrib.hashCode ^
        isha.hashCode;
  }

  /// Creates a copy of this PrayerTimes with the given fields replaced
  PrayerTimes copyWith({
    String? fajr,
    String? sunrise,
    String? dhuhr,
    String? asr,
    String? maghrib,
    String? isha,
  }) {
    return PrayerTimes(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}