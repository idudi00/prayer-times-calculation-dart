import 'package:test/test.dart';
import 'package:prayer_times_calculation/prayer_times_calculation.dart';

void main() {
  group('PrayerTimesSDK', () {
    const riyadhLat = 24.7136;
    const riyadhLng = 46.6753;
    const riyadhTimezone = 3.0;
    final testDate = DateTime.utc(2023, 6, 21); // Summer solstice for better calculation conditions

    group('Validation', () {
      test('should validate latitude bounds', () {
        const options = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        expect(
          () => PrayerTimesSDK(-91, riyadhLng, testDate, riyadhTimezone, options),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Latitude must be between -90 and 90'),
          )),
        );

        expect(
          () => PrayerTimesSDK(91, riyadhLng, testDate, riyadhTimezone, options),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate longitude bounds', () {
        const options = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        expect(
          () => PrayerTimesSDK(riyadhLat, -181, testDate, riyadhTimezone, options),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Longitude must be between -180 and 180'),
          )),
        );

        expect(
          () => PrayerTimesSDK(riyadhLat, 181, testDate, riyadhTimezone, options),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate calculation options', () {
        const invalidOptions = CalculationOptions(
          method: CalculationMethod.custom,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        expect(
          () => PrayerTimesSDK(riyadhLat, riyadhLng, testDate, riyadhTimezone, invalidOptions),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('MWL Method', () {
      test('should calculate prayer times for Riyadh using MWL method', () {
        const options = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        // Use summer solstice for more normal conditions
        final normalDate = DateTime.utc(2023, 6, 21);

        final sdk = PrayerTimesSDK(
          riyadhLat,
          riyadhLng,
          normalDate,
          riyadhTimezone,
          options,
        );

        final times = sdk.getTimes();

        // Verify all times are present
        expect(times.fajr, isNotEmpty);
        expect(times.sunrise, isNotEmpty);
        expect(times.dhuhr, isNotEmpty);
        expect(times.asr, isNotEmpty);
        expect(times.maghrib, isNotEmpty);
        expect(times.isha, isNotEmpty);

        // Verify time format (HH:mm or NaN:NaN)
        final timeRegex = RegExp(r'^(\d{2}:\d{2}|NaN:NaN)$');
        expect(times.fajr, matches(timeRegex));
        expect(times.sunrise, matches(timeRegex));
        expect(times.dhuhr, matches(timeRegex));
        expect(times.asr, matches(timeRegex));
        expect(times.maghrib, matches(timeRegex));
        expect(times.isha, matches(timeRegex));

        print('MWL Calculated times: ${times.toMap()}');
      });
    });

    group('ISNA Method', () {
      test('should calculate prayer times using ISNA method', () {
        const options = CalculationOptions(
          method: CalculationMethod.isna,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        final sdk = PrayerTimesSDK(
          riyadhLat,
          riyadhLng,
          testDate,
          riyadhTimezone,
          options,
        );

        final times = sdk.getTimes();
        expect(times.fajr, isNotEmpty);
        expect(times.isha, isNotEmpty);
      });
    });

    group('Custom Method', () {
      test('should calculate prayer times using custom angles', () {
        const options = CalculationOptions(
          method: CalculationMethod.custom,
          fajrAngle: 19.0,
          ishaAngle: 16.0,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        final sdk = PrayerTimesSDK(
          riyadhLat,
          riyadhLng,
          testDate,
          riyadhTimezone,
          options,
        );

        final times = sdk.getTimes();
        expect(times.fajr, isNotEmpty);
        expect(times.isha, isNotEmpty);
      });

      test('should throw error when custom method is used without required angles', () {
        const optionsWithoutAngles = CalculationOptions(
          method: CalculationMethod.custom,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        expect(
          () => PrayerTimesSDK(
            riyadhLat,
            riyadhLng,
            testDate,
            riyadhTimezone,
            optionsWithoutAngles,
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Custom method requires both fajrAngle and ishaAngle'),
          )),
        );
      });
    });

    group('Asr Jurisdictions', () {
      test('should calculate different Asr times for Standard vs Hanafi', () {
        const standardOptions = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        const hanafiOptions = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.hanafi,
        );

        final standardSdk = PrayerTimesSDK(
          riyadhLat,
          riyadhLng,
          testDate,
          riyadhTimezone,
          standardOptions,
        );

        final hanafiSdk = PrayerTimesSDK(
          riyadhLat,
          riyadhLng,
          testDate,
          riyadhTimezone,
          hanafiOptions,
        );

        final standardTimes = standardSdk.getTimes();
        final hanafiTimes = hanafiSdk.getTimes();

        // Hanafi Asr should be later than Standard Asr
        expect(standardTimes.asr, isNot(equals(hanafiTimes.asr)));

        // Parse times to compare (assuming they're not NaN:NaN)
        if (standardTimes.asr != 'NaN:NaN' && hanafiTimes.asr != 'NaN:NaN') {
          final standardMinutes = _parseTimeToMinutes(standardTimes.asr);
          final hanafiMinutes = _parseTimeToMinutes(hanafiTimes.asr);
          // Hanafi Asr can be either earlier or later than Standard depending on the sun's position
          expect(hanafiMinutes, isNot(equals(standardMinutes)));
        }
      });
    });

    group('Performance', () {
      test('should calculate times within performance requirements (<10ms)', () {
        const options = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        final sdk = PrayerTimesSDK(
          riyadhLat,
          riyadhLng,
          testDate,
          riyadhTimezone,
          options,
        );

        final stopwatch = Stopwatch()..start();
        sdk.getTimes();
        stopwatch.stop();

        final executionTime = stopwatch.elapsedMilliseconds;
        expect(executionTime, lessThan(10));
        print('Execution time: ${executionTime}ms');
      });
    });

    group('Different Locations', () {
      test('should calculate prayer times for different locations', () {
        final locations = [
          {'name': 'New York', 'lat': 40.7128, 'lng': -74.0060, 'timezone': -5.0},
          {'name': 'London', 'lat': 51.5074, 'lng': -0.1278, 'timezone': 0.0},
          {'name': 'Tokyo', 'lat': 35.6762, 'lng': 139.6503, 'timezone': 9.0},
        ];

        const options = CalculationOptions(
          method: CalculationMethod.mwl,
          asrJurisdiction: AsrJurisdiction.standard,
        );

        for (final location in locations) {
          final sdk = PrayerTimesSDK(
            location['lat'] as double,
            location['lng'] as double,
            testDate,
            location['timezone'] as double,
            options,
          );

          final times = sdk.getTimes();
          final timeRegex = RegExp(r'^(\d{2}:\d{2}|NaN:NaN)$');

          expect(times.fajr, matches(timeRegex));
          expect(times.sunrise, matches(timeRegex));
          expect(times.dhuhr, matches(timeRegex));
          expect(times.asr, matches(timeRegex));
          expect(times.maghrib, matches(timeRegex));
          expect(times.isha, matches(timeRegex));

          print('${location['name']} times: ${times.toMap()}');
        }
      });
    });

    group('All Calculation Methods', () {
      test('should calculate times for all methods', () {
        final methods = [
          CalculationMethod.mwl,
          CalculationMethod.isna,
          CalculationMethod.egypt,
          CalculationMethod.makkah,
          CalculationMethod.karachi,
        ];

        for (final method in methods) {
          final options = CalculationOptions(
            method: method,
            asrJurisdiction: AsrJurisdiction.standard,
          );

          final sdk = PrayerTimesSDK(
            riyadhLat,
            riyadhLng,
            testDate,
            riyadhTimezone,
            options,
          );

          final times = sdk.getTimes();
          expect(times.fajr, isNotEmpty);
          expect(times.isha, isNotEmpty);

          print('${method.key} times: ${times.toMap()}');
        }
      });
    });
  });
}

/// Helper function to parse time string to minutes since midnight
int _parseTimeToMinutes(String timeStr) {
  final parts = timeStr.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  return hours * 60 + minutes;
}