import 'package:test/test.dart';
import 'package:prayer_times_calculation/prayer_times_calculation.dart';

void main() {
  group('CalculationMethod', () {
    test('should have correct display names', () {
      expect(CalculationMethod.mwl.displayName, equals('Muslim World League'));
      expect(CalculationMethod.isna.displayName, equals('Islamic Society of North America'));
      expect(CalculationMethod.egypt.displayName, equals('Egyptian General Authority'));
      expect(CalculationMethod.makkah.displayName, equals('Umm Al-Qura University'));
      expect(CalculationMethod.karachi.displayName, equals('University of Islamic Sciences, Karachi'));
      expect(CalculationMethod.custom.displayName, equals('Custom'));
    });

    test('should have correct keys', () {
      expect(CalculationMethod.mwl.key, equals('MWL'));
      expect(CalculationMethod.isna.key, equals('ISNA'));
      expect(CalculationMethod.egypt.key, equals('Egypt'));
      expect(CalculationMethod.makkah.key, equals('Makkah'));
      expect(CalculationMethod.karachi.key, equals('Karachi'));
      expect(CalculationMethod.custom.key, equals('Custom'));
    });
  });

  group('AsrJurisdiction', () {
    test('should have correct display names', () {
      expect(AsrJurisdiction.standard.displayName, equals('Standard (Shafi/Maliki/Hanbali)'));
      expect(AsrJurisdiction.hanafi.displayName, equals('Hanafi'));
    });

    test('should have correct shadow factors', () {
      expect(AsrJurisdiction.standard.shadowFactor, equals(1));
      expect(AsrJurisdiction.hanafi.shadowFactor, equals(2));
    });
  });

  group('MethodAngles', () {
    test('should create instance with correct values', () {
      const angles = MethodAngles(fajr: 18.0, isha: 17.0);
      expect(angles.fajr, equals(18.0));
      expect(angles.isha, equals(17.0));
    });

    test('should support equality comparison', () {
      const angles1 = MethodAngles(fajr: 18.0, isha: 17.0);
      const angles2 = MethodAngles(fajr: 18.0, isha: 17.0);
      const angles3 = MethodAngles(fajr: 15.0, isha: 15.0);

      expect(angles1, equals(angles2));
      expect(angles1, isNot(equals(angles3)));
    });

    test('should support copyWith', () {
      const original = MethodAngles(fajr: 18.0, isha: 17.0);
      final modified = original.copyWith(fajr: 19.0);

      expect(modified.fajr, equals(19.0));
      expect(modified.isha, equals(17.0));
    });
  });

  group('CalculationOptions', () {
    test('should create valid options', () {
      const options = CalculationOptions(
        method: CalculationMethod.mwl,
        asrJurisdiction: AsrJurisdiction.standard,
      );

      expect(options.method, equals(CalculationMethod.mwl));
      expect(options.asrJurisdiction, equals(AsrJurisdiction.standard));
    });

    test('should validate custom method with angles', () {
      const options = CalculationOptions(
        method: CalculationMethod.custom,
        asrJurisdiction: AsrJurisdiction.standard,
        fajrAngle: 18.0,
        ishaAngle: 16.0,
      );

      expect(() => options.validate(), returnsNormally);
    });

    test('should throw error for custom method without angles', () {
      const options = CalculationOptions(
        method: CalculationMethod.custom,
        asrJurisdiction: AsrJurisdiction.standard,
      );

      expect(
        () => options.validate(),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Custom method requires both fajrAngle and ishaAngle'),
        )),
      );
    });
  });

  group('PrayerTimes', () {
    test('should create instance with all times', () {
      const times = PrayerTimes(
        fajr: '04:32',
        sunrise: '05:52',
        dhuhr: '12:15',
        asr: '15:42',
        maghrib: '18:38',
        isha: '20:08',
      );

      expect(times.fajr, equals('04:32'));
      expect(times.sunrise, equals('05:52'));
      expect(times.dhuhr, equals('12:15'));
      expect(times.asr, equals('15:42'));
      expect(times.maghrib, equals('18:38'));
      expect(times.isha, equals('20:08'));
    });

    test('should convert to map', () {
      const times = PrayerTimes(
        fajr: '04:32',
        sunrise: '05:52',
        dhuhr: '12:15',
        asr: '15:42',
        maghrib: '18:38',
        isha: '20:08',
      );

      final map = times.toMap();
      expect(map['fajr'], equals('04:32'));
      expect(map['isha'], equals('20:08'));
    });

    test('should support copyWith', () {
      const original = PrayerTimes(
        fajr: '04:32',
        sunrise: '05:52',
        dhuhr: '12:15',
        asr: '15:42',
        maghrib: '18:38',
        isha: '20:08',
      );

      final modified = original.copyWith(fajr: '04:30');
      expect(modified.fajr, equals('04:30'));
      expect(modified.sunrise, equals('05:52'));
    });
  });
}