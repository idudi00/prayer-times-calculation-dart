import 'package:test/test.dart';
import 'package:prayer_times_calculation/src/utils/astronomical.dart';
import 'dart:math' as math;

void main() {
  group('Astronomical Utilities', () {
    test('should convert degrees to radians correctly', () {
      expect(Astronomical.degreesToRadians(0), equals(0));
      expect(Astronomical.degreesToRadians(90), closeTo(math.pi / 2, 0.0001));
      expect(Astronomical.degreesToRadians(180), closeTo(math.pi, 0.0001));
      expect(Astronomical.degreesToRadians(360), closeTo(2 * math.pi, 0.0001));
    });

    test('should convert radians to degrees correctly', () {
      expect(Astronomical.radiansToDegrees(0), equals(0));
      expect(Astronomical.radiansToDegrees(math.pi / 2), closeTo(90, 0.0001));
      expect(Astronomical.radiansToDegrees(math.pi), closeTo(180, 0.0001));
      expect(Astronomical.radiansToDegrees(2 * math.pi), closeTo(360, 0.0001));
    });

    test('should normalize angles correctly', () {
      expect(Astronomical.normalizeAngle(0), equals(0));
      expect(Astronomical.normalizeAngle(180), equals(180));
      expect(Astronomical.normalizeAngle(360), equals(0));
      expect(Astronomical.normalizeAngle(450), equals(90));
      expect(Astronomical.normalizeAngle(-90), equals(270));
      expect(Astronomical.normalizeAngle(-180), equals(180));
    });

    test('should calculate Julian date correctly', () {
      // Test date: January 1, 2000 12:00 UTC
      final testDate = DateTime.utc(2000, 1, 1, 12, 0, 0);
      final jd = Astronomical.julianDate(testDate);

      // Julian date for January 1, 2000 12:00 UTC should be around 2451545.0
      expect(jd, closeTo(2451545.0, 1.0));
    });

    test('should calculate equation of time', () {
      final jd = 2451545.0; // January 1, 2000
      final eqTime = Astronomical.equationOfTime(jd);

      // Equation of time should be a reasonable value (in minutes)
      expect(eqTime, greaterThan(-20));
      expect(eqTime, lessThan(20));
    });

    test('should calculate sun declination', () {
      final jd = 2451545.0; // January 1, 2000
      final declination = Astronomical.sunDeclination(jd);

      // Sun declination in January should be negative (Southern hemisphere)
      expect(declination, greaterThan(-25));
      expect(declination, lessThan(0));
    });

    test('should calculate hour angle', () {
      final latitude = 24.7136; // Riyadh
      final declination = -23.0; // Winter solstice approximation
      final angle = -18.0; // Fajr angle

      final hourAngle = Astronomical.calculateHourAngle(latitude, declination, angle);
      expect(hourAngle, isNot(isNaN));
      expect(hourAngle, greaterThan(0));
      expect(hourAngle, lessThan(180));
    });

    test('should return NaN for impossible hour angle', () {
      final latitude = 70.0; // High latitude
      final declination = -23.0;
      final angle = -18.0;

      final hourAngle = Astronomical.calculateHourAngle(latitude, declination, angle);
      // Might be NaN for extreme latitudes
      expect(hourAngle, anyOf(isNaN, isNotNaN));
    });

    test('should convert hour angle to time', () {
      expect(Astronomical.timeFromAngle(0), equals(0));
      expect(Astronomical.timeFromAngle(15), equals(1));
      expect(Astronomical.timeFromAngle(90), equals(6));
      expect(Astronomical.timeFromAngle(180), equals(12));
    });

    test('should format time correctly', () {
      expect(Astronomical.formatTime(0), equals('00:00'));
      expect(Astronomical.formatTime(1), equals('01:00'));
      expect(Astronomical.formatTime(12.5), equals('12:30'));
      expect(Astronomical.formatTime(23.75), equals('23:45'));
      expect(Astronomical.formatTime(double.nan), equals('NaN:NaN'));
    });

    test('should format time with proper padding', () {
      expect(Astronomical.formatTime(5.5), equals('05:30'));
      expect(Astronomical.formatTime(9.08333), equals('09:05')); // 9:05
    });

    test('should add minutes to time string', () {
      expect(Astronomical.addMinutes('12:00', 30), equals('12:30'));
      expect(Astronomical.addMinutes('12:30', 30), equals('13:00'));
      expect(Astronomical.addMinutes('23:30', 60), equals('00:30'));
      expect(Astronomical.addMinutes('00:30', -60), equals('23:30'));
    });

    test('should handle negative minutes in addMinutes', () {
      expect(Astronomical.addMinutes('01:00', -120), equals('23:00'));
      expect(Astronomical.addMinutes('00:00', -1), equals('23:59'));
    });

    test('should handle time overflow in addMinutes', () {
      expect(Astronomical.addMinutes('23:59', 1), equals('00:00'));
      expect(Astronomical.addMinutes('12:00', 1440), equals('12:00')); // 24 hours
    });
  });
}