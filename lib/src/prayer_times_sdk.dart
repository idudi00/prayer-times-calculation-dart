import 'dart:math' as math;

import 'models/calculation_options.dart';
import 'models/prayer_times.dart';
import 'models/asr_jurisdiction.dart';
import 'methods.dart';
import 'utils/astronomical.dart';

/// Main SDK class for calculating Islamic prayer times
class PrayerTimesSDK {
  /// Creates a new PrayerTimesSDK instance
  PrayerTimesSDK(
    this.latitude,
    this.longitude,
    this.date,
    this.timezone,
    this.options,
  ) {
    _validateInputs();
    options.validate();
  }

  /// Geographic latitude (-90 to 90)
  final double latitude;

  /// Geographic longitude (-180 to 180)
  final double longitude;

  /// Date for calculation
  final DateTime date;

  /// UTC offset in hours (e.g., 3 for UTC+3, -5 for UTC-5)
  final double timezone;

  /// Calculation configuration options
  final CalculationOptions options;

  /// Validates input parameters
  void _validateInputs() {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90 degrees');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180 degrees');
    }
  }

  /// Calculate and return prayer times
  PrayerTimes getTimes() {
    final jd = Astronomical.julianDate(date);
    final declination = Astronomical.sunDeclination(jd);
    final eqTime = Astronomical.equationOfTime(jd);
    final angles = CalculationMethods.getMethodAngles(
      options.method,
      customFajr: options.fajrAngle,
      customIsha: options.ishaAngle,
    );

    final dhuhr = _calculateDhuhr(eqTime);
    final sunrise = _calculateSunrise(declination, eqTime);
    final sunset = _calculateSunset(declination, eqTime);
    final fajr = _calculateFajr(declination, eqTime, angles.fajr);
    final isha = _calculateIsha(declination, eqTime, angles.isha);
    final asr = _calculateAsr(declination, eqTime, options.asrJurisdiction);

    final sunsetTime = Astronomical.formatTime(sunset);
    final maghribTime = sunsetTime == 'NaN:NaN'
        ? 'NaN:NaN'
        : Astronomical.addMinutes(sunsetTime, 1);

    return PrayerTimes(
      fajr: Astronomical.formatTime(fajr),
      sunrise: Astronomical.formatTime(sunrise),
      dhuhr: Astronomical.formatTime(dhuhr),
      asr: Astronomical.formatTime(asr),
      maghrib: maghribTime,
      isha: Astronomical.formatTime(isha),
    );
  }

  /// Calculate Dhuhr (noon) prayer time
  double _calculateDhuhr(double eqTime) {
    final timeCorrection = eqTime + 4 * longitude - 60 * timezone;
    final solarNoon = 12 - timeCorrection / 60;
    return solarNoon + 2 / 60;
  }

  /// Calculate sunrise time
  double _calculateSunrise(double declination, double eqTime) {
    final hourAngle =
        Astronomical.calculateHourAngle(latitude, declination, -0.833);
    if (hourAngle.isNaN) return double.nan;

    final timeCorrection = eqTime + 4 * longitude - 60 * timezone;
    final sunrise =
        12 - Astronomical.timeFromAngle(hourAngle) - timeCorrection / 60;

    return sunrise >= 0 ? sunrise : sunrise + 24;
  }

  /// Calculate sunset time
  double _calculateSunset(double declination, double eqTime) {
    final hourAngle =
        Astronomical.calculateHourAngle(latitude, declination, -0.833);
    if (hourAngle.isNaN) return double.nan;

    final timeCorrection = eqTime + 4 * longitude - 60 * timezone;
    final sunset =
        12 + Astronomical.timeFromAngle(hourAngle) - timeCorrection / 60;
    return sunset >= 0 ? sunset : sunset + 24;
  }

  /// Calculate Fajr (dawn) prayer time
  double _calculateFajr(double declination, double eqTime, double fajrAngle) {
    final hourAngle =
        Astronomical.calculateHourAngle(latitude, declination, -fajrAngle);
    if (hourAngle.isNaN) return double.nan;

    final timeCorrection = eqTime + 4 * longitude - 60 * timezone;
    final fajr =
        12 - Astronomical.timeFromAngle(hourAngle) - timeCorrection / 60;
    return fajr >= 0 ? fajr : fajr + 24;
  }

  /// Calculate Isha (night) prayer time
  double _calculateIsha(double declination, double eqTime, double ishaAngle) {
    final hourAngle =
        Astronomical.calculateHourAngle(latitude, declination, -ishaAngle);
    if (hourAngle.isNaN) return double.nan;

    final timeCorrection = eqTime + 4 * longitude - 60 * timezone;
    final isha =
        12 + Astronomical.timeFromAngle(hourAngle) - timeCorrection / 60;
    return isha >= 0 ? isha : isha + 24;
  }

  /// Calculate Asr (afternoon) prayer time
  double _calculateAsr(
      double declination, double eqTime, AsrJurisdiction jurisdiction) {
    final shadowFactor = jurisdiction.shadowFactor;
    final latRad = Astronomical.degreesToRadians(latitude);
    final decRad = Astronomical.degreesToRadians(declination);

    final tanAltitude = 1 / (shadowFactor + math.tan((latRad - decRad).abs()));
    final altitude = Astronomical.radiansToDegrees(math.atan(tanAltitude));

    final hourAngle =
        Astronomical.calculateHourAngle(latitude, declination, 90 - altitude);
    if (hourAngle.isNaN) return double.nan;

    final timeCorrection = eqTime + 4 * longitude - 60 * timezone;
    final asr =
        12 + Astronomical.timeFromAngle(hourAngle) - timeCorrection / 60;
    return asr >= 0 ? asr : asr + 24;
  }
}
