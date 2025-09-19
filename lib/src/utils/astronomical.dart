import 'dart:math' as math;

/// Utility functions for astronomical calculations
class Astronomical {
  /// Convert degrees to radians
  static double degreesToRadians(double degrees) {
    return (degrees * math.pi) / 180;
  }

  /// Convert radians to degrees
  static double radiansToDegrees(double radians) {
    return (radians * 180) / math.pi;
  }

  /// Normalize angle to 0-360 range
  static double normalizeAngle(double angle) {
    angle = angle % 360;
    return angle < 0 ? angle + 360 : angle;
  }

  /// Calculate Julian date from DateTime
  static double julianDate(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    int adjustedYear = year;
    int adjustedMonth = month;

    if (month <= 2) {
      adjustedYear -= 1;
      adjustedMonth += 12;
    }

    final a = (adjustedYear / 100).floor();
    final b = 2 - a + (a / 4).floor();

    return (365.25 * (adjustedYear + 4716)).floor() +
        (30.6001 * (adjustedMonth + 1)).floor() +
        day +
        b -
        1524.5;
  }

  /// Calculate equation of time
  static double equationOfTime(double jd) {
    final n = jd - 2451545.0;
    final l = normalizeAngle(280.460 + 0.9856474 * n);
    final g = degreesToRadians(normalizeAngle(357.528 + 0.9856003 * n));
    final lambda = degreesToRadians(l + 1.915 * math.sin(g) + 0.020 * math.sin(2 * g));

    final alpha = math.atan2(
      math.cos(degreesToRadians(23.439)) * math.sin(lambda),
      math.cos(lambda),
    );
    final deltaAlpha = l - radiansToDegrees(alpha);

    if (deltaAlpha > 180) return (deltaAlpha - 360) * 4;
    if (deltaAlpha < -180) return (deltaAlpha + 360) * 4;
    return deltaAlpha * 4;
  }

  /// Calculate sun declination
  static double sunDeclination(double jd) {
    final n = jd - 2451545.0;
    final l = normalizeAngle(280.460 + 0.9856474 * n);
    final g = degreesToRadians(normalizeAngle(357.528 + 0.9856003 * n));
    final lambda = degreesToRadians(l + 1.915 * math.sin(g) + 0.020 * math.sin(2 * g));

    return radiansToDegrees(
      math.asin(math.sin(degreesToRadians(23.439)) * math.sin(lambda)),
    );
  }

  /// Calculate hour angle
  static double calculateHourAngle(double latitude, double declination, double angle) {
    final latRad = degreesToRadians(latitude);
    final decRad = degreesToRadians(declination);
    final angleRad = degreesToRadians(angle);

    final cosHourAngle = (math.sin(angleRad) - math.sin(decRad) * math.sin(latRad)) /
        (math.cos(decRad) * math.cos(latRad));

    if (cosHourAngle.abs() > 1) {
      return double.nan;
    }

    return radiansToDegrees(math.acos(cosHourAngle));
  }

  /// Convert hour angle to time
  static double timeFromAngle(double hourAngle) {
    return hourAngle / 15;
  }

  /// Format hours to HH:mm string
  static String formatTime(double hours) {
    if (hours.isNaN) return 'NaN:NaN';

    final totalMinutes = (hours * 60).round();
    final h = (totalMinutes / 60).floor() % 24;
    final m = totalMinutes % 60;

    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  /// Add minutes to a time string
  static String addMinutes(String timeStr, int minutes) {
    final parts = timeStr.split(':').map(int.parse).toList();
    final hours = parts[0];
    final mins = parts[1];
    int totalMinutes = hours * 60 + mins + minutes;

    while (totalMinutes < 0) {
      totalMinutes += 24 * 60;
    }

    final newHours = (totalMinutes / 60).floor() % 24;
    final newMins = totalMinutes % 60;

    return '${newHours.toString().padLeft(2, '0')}:${newMins.toString().padLeft(2, '0')}';
  }
}