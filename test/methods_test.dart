import 'package:test/test.dart';
import 'package:prayer_times_calculation/prayer_times_calculation.dart';

void main() {
  group('CalculationMethods', () {
    test('should return correct angles for MWL method', () {
      final angles = CalculationMethods.getMethodAngles(CalculationMethod.mwl);
      expect(angles.fajr, equals(18.0));
      expect(angles.isha, equals(17.0));
    });

    test('should return correct angles for ISNA method', () {
      final angles = CalculationMethods.getMethodAngles(CalculationMethod.isna);
      expect(angles.fajr, equals(15.0));
      expect(angles.isha, equals(15.0));
    });

    test('should return correct angles for Egypt method', () {
      final angles = CalculationMethods.getMethodAngles(CalculationMethod.egypt);
      expect(angles.fajr, equals(19.5));
      expect(angles.isha, equals(17.5));
    });

    test('should return correct angles for Makkah method', () {
      final angles = CalculationMethods.getMethodAngles(CalculationMethod.makkah);
      expect(angles.fajr, equals(18.5));
      expect(angles.isha, equals(18.5));
    });

    test('should return correct angles for Karachi method', () {
      final angles = CalculationMethods.getMethodAngles(CalculationMethod.karachi);
      expect(angles.fajr, equals(18.0));
      expect(angles.isha, equals(18.0));
    });

    test('should return custom angles when provided', () {
      final angles = CalculationMethods.getMethodAngles(
        CalculationMethod.custom,
        customFajr: 19.0,
        customIsha: 16.0,
      );
      expect(angles.fajr, equals(19.0));
      expect(angles.isha, equals(16.0));
    });

    test('should throw error for custom method without angles', () {
      expect(
        () => CalculationMethods.getMethodAngles(CalculationMethod.custom),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Custom method requires both fajrAngle and ishaAngle'),
        )),
      );
    });

    test('should throw error for custom method with partial angles', () {
      expect(
        () => CalculationMethods.getMethodAngles(
          CalculationMethod.custom,
          customFajr: 18.0,
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => CalculationMethods.getMethodAngles(
          CalculationMethod.custom,
          customIsha: 17.0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should return all available methods', () {
      final methods = CalculationMethods.allMethods;
      expect(methods, contains(CalculationMethod.mwl));
      expect(methods, contains(CalculationMethod.isna));
      expect(methods, contains(CalculationMethod.egypt));
      expect(methods, contains(CalculationMethod.makkah));
      expect(methods, contains(CalculationMethod.karachi));
      expect(methods, contains(CalculationMethod.custom));
      expect(methods.length, equals(6));
    });

    test('should check predefined angles correctly', () {
      expect(CalculationMethods.hasPredefineAngles(CalculationMethod.mwl), isTrue);
      expect(CalculationMethods.hasPredefineAngles(CalculationMethod.isna), isTrue);
      expect(CalculationMethods.hasPredefineAngles(CalculationMethod.egypt), isTrue);
      expect(CalculationMethods.hasPredefineAngles(CalculationMethod.makkah), isTrue);
      expect(CalculationMethods.hasPredefineAngles(CalculationMethod.karachi), isTrue);
      expect(CalculationMethods.hasPredefineAngles(CalculationMethod.custom), isFalse);
    });

    test('should return correct method descriptions', () {
      expect(
        CalculationMethods.getMethodDescription(CalculationMethod.mwl),
        equals('Muslim World League (Fajr: 18°, Isha: 17°)'),
      );
      expect(
        CalculationMethods.getMethodDescription(CalculationMethod.isna),
        equals('Islamic Society of North America (Fajr: 15°, Isha: 15°)'),
      );
      expect(
        CalculationMethods.getMethodDescription(CalculationMethod.egypt),
        equals('Egyptian General Authority (Fajr: 19.5°, Isha: 17.5°)'),
      );
      expect(
        CalculationMethods.getMethodDescription(CalculationMethod.makkah),
        equals('Umm Al-Qura University (Fajr: 18.5°, Isha: 18.5°)'),
      );
      expect(
        CalculationMethods.getMethodDescription(CalculationMethod.karachi),
        equals('University of Islamic Sciences, Karachi (Fajr: 18°, Isha: 18°)'),
      );
      expect(
        CalculationMethods.getMethodDescription(CalculationMethod.custom),
        equals('Custom angles specified by user'),
      );
    });
  });
}