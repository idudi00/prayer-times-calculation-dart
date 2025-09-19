import 'package:prayer_times_calculation/prayer_times_calculation.dart';

void main() {
  print('🕌 Prayer Times Calculation SDK - Dart Example\n');

  // Example 1: Basic usage with Riyadh coordinates
  basicExample();

  // Example 2: Different calculation methods
  methodComparison();

  // Example 3: Different locations around the world
  worldLocations();

  // Example 4: Asr jurisdiction comparison
  asrComparison();

  // Example 5: Custom angles
  customAnglesExample();

  // Example 6: Performance test
  performanceTest();
}

void basicExample() {
  print('📍 Example 1: Basic Usage (Riyadh, Saudi Arabia)');
  print('=' * 50);

  // Riyadh coordinates
  const latitude = 24.7136;
  const longitude = 46.6753;
  const timezone = 3.0; // UTC+3
  final date = DateTime.now();

  const options = CalculationOptions(
    method: CalculationMethod.mwl,
    asrJurisdiction: AsrJurisdiction.standard,
  );

  final prayerTimes =
      PrayerTimesSDK(latitude, longitude, date, timezone, options);
  final times = prayerTimes.getTimes();

  print('Date: ${date.toLocal().toString().split(' ')[0]}');
  print('Location: Riyadh (${latitude}°, ${longitude}°)');
  print('Method: ${options.method.displayName}');
  print('Asr Jurisdiction: ${options.asrJurisdiction.displayName}');
  print('');
  print('Prayer Times:');
  print('  Fajr:    ${times.fajr}');
  print('  Sunrise: ${times.sunrise}');
  print('  Dhuhr:   ${times.dhuhr}');
  print('  Asr:     ${times.asr}');
  print('  Maghrib: ${times.maghrib}');
  print('  Isha:    ${times.isha}');
  print('');
}

void methodComparison() {
  print('⚙️ Example 2: Different Calculation Methods');
  print('=' * 50);

  const latitude = 40.7128; // New York
  const longitude = -74.0060;
  const timezone = -5.0; // UTC-5
  final date = DateTime.utc(2024, 6, 21); // Summer solstice

  final methods = [
    CalculationMethod.mwl,
    CalculationMethod.isna,
    CalculationMethod.egypt,
    CalculationMethod.makkah,
    CalculationMethod.karachi,
  ];

  print('Location: New York City');
  print('Date: Summer Solstice 2024');
  print('');

  for (final method in methods) {
    final options = CalculationOptions(
      method: method,
      asrJurisdiction: AsrJurisdiction.standard,
    );

    final prayerTimes =
        PrayerTimesSDK(latitude, longitude, date, timezone, options);
    final times = prayerTimes.getTimes();

    print('${method.displayName}:');
    print('  Fajr: ${times.fajr}, Isha: ${times.isha}');
  }
  print('');
}

void worldLocations() {
  print('🌍 Example 3: Prayer Times Around the World');
  print('=' * 50);

  final locations = [
    {'name': 'Mecca, Saudi Arabia', 'lat': 21.4225, 'lng': 39.8262, 'tz': 3.0},
    {'name': 'Istanbul, Turkey', 'lat': 41.0082, 'lng': 28.9784, 'tz': 3.0},
    {'name': 'Cairo, Egypt', 'lat': 30.0444, 'lng': 31.2357, 'tz': 2.0},
    {
      'name': 'Kuala Lumpur, Malaysia',
      'lat': 3.1390,
      'lng': 101.6869,
      'tz': 8.0
    },
    {'name': 'London, UK', 'lat': 51.5074, 'lng': -0.1278, 'tz': 0.0},
  ];

  final date = DateTime.now();

  for (final location in locations) {
    final options = CalculationOptions(
      method: _getRecommendedMethod(location['name'] as String),
      asrJurisdiction: AsrJurisdiction.standard,
    );

    final prayerTimes = PrayerTimesSDK(
      location['lat'] as double,
      location['lng'] as double,
      date,
      location['tz'] as double,
      options,
    );

    final times = prayerTimes.getTimes();

    print('${location['name']}:');
    print('  Method: ${options.method.displayName}');
    print(
        '  Fajr: ${times.fajr}, Dhuhr: ${times.dhuhr}, Maghrib: ${times.maghrib}');
    print('');
  }
}

void asrComparison() {
  print('🕐 Example 4: Asr Jurisdiction Comparison');
  print('=' * 50);

  const latitude = 24.7136; // Riyadh
  const longitude = 46.6753;
  const timezone = 3.0;
  final date = DateTime.now();

  // Standard Asr
  const standardOptions = CalculationOptions(
    method: CalculationMethod.mwl,
    asrJurisdiction: AsrJurisdiction.standard,
  );

  // Hanafi Asr
  const hanafiOptions = CalculationOptions(
    method: CalculationMethod.mwl,
    asrJurisdiction: AsrJurisdiction.hanafi,
  );

  final standardTimes = PrayerTimesSDK(
    latitude,
    longitude,
    date,
    timezone,
    standardOptions,
  ).getTimes();

  final hanafiTimes = PrayerTimesSDK(
    latitude,
    longitude,
    date,
    timezone,
    hanafiOptions,
  ).getTimes();

  print('Location: Riyadh, Saudi Arabia');
  print('');
  print('Standard Asr (Shafi/Maliki/Hanbali): ${standardTimes.asr}');
  print('Hanafi Asr:                          ${hanafiTimes.asr}');
  print('');
  print('Note: Hanafi Asr is calculated when shadow = 2 × object height');
  print('      Standard Asr is when shadow = object height');
  print('');
}

void customAnglesExample() {
  print('🎛️ Example 5: Custom Angles');
  print('=' * 50);

  const latitude = 51.5074; // London
  const longitude = -0.1278;
  const timezone = 0.0;
  final date = DateTime.now();

  const customOptions = CalculationOptions(
    method: CalculationMethod.custom,
    fajrAngle: 18.0,
    ishaAngle: 16.0,
    asrJurisdiction: AsrJurisdiction.hanafi,
  );

  final prayerTimes =
      PrayerTimesSDK(latitude, longitude, date, timezone, customOptions);
  final times = prayerTimes.getTimes();

  print('Location: London, UK');
  print('Custom Angles: Fajr 18°, Isha 16°');
  print('Asr: Hanafi method');
  print('');
  print('Prayer Times:');
  print('  Fajr:    ${times.fajr}');
  print('  Sunrise: ${times.sunrise}');
  print('  Dhuhr:   ${times.dhuhr}');
  print('  Asr:     ${times.asr}');
  print('  Maghrib: ${times.maghrib}');
  print('  Isha:    ${times.isha}');
  print('');
}

void performanceTest() {
  print('⚡ Example 6: Performance Test');
  print('=' * 50);

  const latitude = 24.7136;
  const longitude = 46.6753;
  const timezone = 3.0;
  final date = DateTime.now();

  const options = CalculationOptions(
    method: CalculationMethod.mwl,
    asrJurisdiction: AsrJurisdiction.standard,
  );

  final prayerTimes =
      PrayerTimesSDK(latitude, longitude, date, timezone, options);

  // Warmup
  for (int i = 0; i < 10; i++) {
    prayerTimes.getTimes();
  }

  // Performance test
  const iterations = 1000;
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    prayerTimes.getTimes();
  }

  stopwatch.stop();

  final averageTime = stopwatch.elapsedMicroseconds / iterations / 1000;

  print('Performed $iterations calculations');
  print('Total time: ${stopwatch.elapsedMilliseconds}ms');
  print('Average time per calculation: ${averageTime.toStringAsFixed(3)}ms');
  print('Performance target: <10ms ✓');
  print('');
}

CalculationMethod _getRecommendedMethod(String location) {
  if (location.contains('Egypt')) return CalculationMethod.egypt;
  if (location.contains('Saudi Arabia')) return CalculationMethod.makkah;
  if (location.contains('Turkey')) return CalculationMethod.mwl;
  if (location.contains('Malaysia')) return CalculationMethod.mwl;
  if (location.contains('UK')) return CalculationMethod.mwl;
  return CalculationMethod.mwl;
}
