# Prayer Times Calculation for Dart

<div align="center">

[![pub package](https://img.shields.io/pub/v/prayer_times_calculation.svg)](https://pub.dev/packages/prayer_times_calculation)
[![pub popularity](https://img.shields.io/pub/popularity/prayer_times_calculation.svg)](https://pub.dev/packages/prayer_times_calculation)
[![pub points](https://img.shields.io/pub/points/prayer_times_calculation.svg)](https://pub.dev/packages/prayer_times_calculation)
[![Dart](https://img.shields.io/badge/Dart-Ready-blue.svg)](https://dart.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-Ready-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero-brightgreen.svg)](#)

*A minimalist, offline Prayer Times calculation SDK for Dart and Flutter applications.*

[Installation](#-installation) •
[Quick Start](#-quick-start) •
[API Reference](#-api-reference) •
[Examples](#-examples) •
[Documentation](#-documentation)

</div>

---

## 🌟 Features

- ✅ **Zero Dependencies**: No external packages required
- ✅ **Offline**: Works completely offline without internet connection
- ✅ **Fast**: Calculations complete in <10ms
- ✅ **Lightweight**: Minimal package size
- ✅ **Accurate**: ±1 minute accuracy compared to official sources
- ✅ **Flexible**: Support for multiple calculation methods and custom angles
- ✅ **Type Safe**: Full Dart type safety with null safety compliance
- ✅ **Universal**: Works in Dart CLI, Flutter mobile, web, and desktop apps
- ✅ **Well-tested**: Comprehensive test suite with 25+ test cases

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  prayer_times_calculation: ^1.0.0
```

Then run:

```bash
dart pub get
```

Or for Flutter projects:

```bash
flutter pub get
```

## 🚀 Quick Start

```dart
import 'package:prayer_times_calculation/prayer_times_calculation.dart';

void main() {
  // Riyadh coordinates
  const latitude = 24.7136;
  const longitude = 46.6753;
  const timezone = 3.0; // UTC+3
  final date = DateTime.now();

  const options = CalculationOptions(
    method: CalculationMethod.mwl,
    asrJurisdiction: AsrJurisdiction.standard,
  );

  final prayerTimes = PrayerTimesSDK(latitude, longitude, date, timezone, options);
  final times = prayerTimes.getTimes();

  print('Prayer Times for Riyadh:');
  print('Fajr:    ${times.fajr}');
  print('Sunrise: ${times.sunrise}');
  print('Dhuhr:   ${times.dhuhr}');
  print('Asr:     ${times.asr}');
  print('Maghrib: ${times.maghrib}');
  print('Isha:    ${times.isha}');
}
```

## 📚 API Reference

### PrayerTimesSDK

Main class for calculating prayer times.

```dart
PrayerTimesSDK(
  double latitude,     // Geographic latitude (-90 to 90)
  double longitude,    // Geographic longitude (-180 to 180)
  DateTime date,       // Date for calculation
  double timezone,     // UTC offset in hours
  CalculationOptions options,
)
```

#### Methods

- `PrayerTimes getTimes()`: Returns calculated prayer times

### CalculationOptions

Configuration for prayer time calculations.

```dart
const CalculationOptions({
  required CalculationMethod method,
  required AsrJurisdiction asrJurisdiction,
  double? fajrAngle,    // Required for custom method
  double? ishaAngle,    // Required for custom method
})
```

### Enums

#### CalculationMethod
- `CalculationMethod.mwl` - Muslim World League
- `CalculationMethod.isna` - Islamic Society of North America
- `CalculationMethod.egypt` - Egyptian General Authority
- `CalculationMethod.makkah` - Umm Al-Qura University
- `CalculationMethod.karachi` - University of Islamic Sciences, Karachi
- `CalculationMethod.custom` - Custom angles

#### AsrJurisdiction
- `AsrJurisdiction.standard` - Standard (Shafi/Maliki/Hanbali)
- `AsrJurisdiction.hanafi` - Hanafi school

### PrayerTimes

Result class containing formatted prayer times.

```dart
class PrayerTimes {
  final String fajr;     // Dawn prayer
  final String sunrise;  // Sunrise time
  final String dhuhr;    // Noon prayer
  final String asr;      // Afternoon prayer
  final String maghrib;  // Sunset prayer
  final String isha;     // Night prayer
}
```

## ⚙️ Calculation Methods

| Method | Fajr Angle | Isha Angle | Description |
|--------|------------|------------|-------------|
| **MWL** | 18° | 17° | Muslim World League |
| **ISNA** | 15° | 15° | Islamic Society of North America |
| **Egypt** | 19.5° | 17.5° | Egyptian General Authority |
| **Makkah** | 18.5° | 18.5° | Umm Al-Qura University |
| **Karachi** | 18° | 18° | University of Islamic Sciences, Karachi |
| **Custom** | Custom | Custom | User-defined angles |

## 🕌 Asr Calculation

- **Standard** (Shafi/Maliki/Hanbali): Shadow length = object height
- **Hanafi**: Shadow length = 2 × object height

## 💡 Examples

### Different Calculation Methods

```dart
// Muslim World League method (Most common)
const mwlOptions = CalculationOptions(
  method: CalculationMethod.mwl,
  asrJurisdiction: AsrJurisdiction.standard,
);

// Islamic Society of North America method
const isnaOptions = CalculationOptions(
  method: CalculationMethod.isna,
  asrJurisdiction: AsrJurisdiction.standard,
);

// Custom angles for specific requirements
const customOptions = CalculationOptions(
  method: CalculationMethod.custom,
  fajrAngle: 18.0,
  ishaAngle: 16.0,
  asrJurisdiction: AsrJurisdiction.hanafi,
);
```

### Different Locations Around the World

```dart
// New York, USA
final nyTimes = PrayerTimesSDK(40.7128, -74.0060, DateTime.now(), -5.0, isnaOptions);

// London, UK
final londonTimes = PrayerTimesSDK(51.5074, -0.1278, DateTime.now(), 0.0, mwlOptions);

// Tokyo, Japan
final tokyoTimes = PrayerTimesSDK(35.6762, 139.6503, DateTime.now(), 9.0, mwlOptions);

// Cairo, Egypt
final cairoOptions = CalculationOptions(
  method: CalculationMethod.egypt,
  asrJurisdiction: AsrJurisdiction.standard,
);
final cairoTimes = PrayerTimesSDK(30.0444, 31.2357, DateTime.now(), 2.0, cairoOptions);
```

### Flutter Widget Example

```dart
import 'package:flutter/material.dart';
import 'package:prayer_times_calculation/prayer_times_calculation.dart';

class PrayerTimesWidget extends StatefulWidget {
  @override
  _PrayerTimesWidgetState createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  PrayerTimes? _times;

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() {
    // Use your location coordinates
    const latitude = 24.7136;  // Riyadh
    const longitude = 46.6753;
    const timezone = 3.0;

    const options = CalculationOptions(
      method: CalculationMethod.mwl,
      asrJurisdiction: AsrJurisdiction.standard,
    );

    final prayerTimes = PrayerTimesSDK(
      latitude,
      longitude,
      DateTime.now(),
      timezone,
      options,
    );

    setState(() {
      _times = prayerTimes.getTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_times == null) {
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        Text('Today\'s Prayer Times', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 16),
        _buildTimeRow('Fajr', _times!.fajr),
        _buildTimeRow('Sunrise', _times!.sunrise),
        _buildTimeRow('Dhuhr', _times!.dhuhr),
        _buildTimeRow('Asr', _times!.asr),
        _buildTimeRow('Maghrib', _times!.maghrib),
        _buildTimeRow('Isha', _times!.isha),
      ],
    );
  }

  Widget _buildTimeRow(String prayer, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(prayer, style: TextStyle(fontSize: 16)),
          Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
```

### Specific Date Calculations

```dart
// Calculate for Ramadan 2024
final ramadanStart = DateTime.utc(2024, 3, 11);
final ramadanTimes = PrayerTimesSDK(24.7136, 46.6753, ramadanStart, 3.0, mwlOptions);

// Calculate for next Friday
final nextFriday = DateTime.now().add(Duration(days: (5 - DateTime.now().weekday + 7) % 7));
final fridayTimes = PrayerTimesSDK(40.7128, -74.0060, nextFriday, -5.0, isnaOptions);
```

## 📊 Performance

The SDK is designed for high performance:

| Metric | Value |
|--------|-------|
| **Execution Time** | <10ms on average hardware |
| **Memory Usage** | <100KB |
| **Package Size** | Minimal |

## 🎯 Accuracy

Prayer times are calculated with **±1 minute accuracy** compared to official Islamic authorities. The calculations use:

- ✓ Standard astronomical formulas
- ✓ Proper solar declination and equation of time
- ✓ Geographic coordinate corrections
- ✓ Timezone adjustments
- ✓ Atmospheric refraction corrections

## 🌐 Platform Support

Works on all Dart and Flutter supported platforms:

| Platform | Support |
|----------|---------|
| **Dart CLI** | ✅ |
| **Flutter Mobile** | ✅ iOS & Android |
| **Flutter Web** | ✅ |
| **Flutter Desktop** | ✅ Windows, macOS, Linux |
| **Flutter Embedded** | ✅ |

## 🧪 Testing

Run the test suite:

```bash
dart test
```

The package includes comprehensive tests covering:
- All calculation methods
- Different geographical locations
- Performance benchmarks
- Edge cases and validation

## 📖 Documentation

### Additional Resources

- [API Documentation](https://pub.dev/documentation/prayer_times_calculation/latest/)
- [Example App](example/main.dart)
- [Migration from TypeScript version](https://github.com/Muslims-Community/prayer-times-calculation-ts)

### Related Projects

- [TypeScript Version](https://www.npmjs.com/package/@muslims-community/prayer-times-calculation)
- [Arabic Documentation](https://github.com/Muslims-Community/prayer-times-calculation-ts/blob/main/README.ar.md)

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
git clone https://github.com/Muslims-Community/prayer-times-calculation-dart.git
cd prayer-times-calculation-dart
dart pub get
dart test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Support

If you find this package helpful, please consider:

- ⭐ Starring the repository
- 👍 Liking the package on [pub.dev](https://pub.dev/packages/prayer_times_calculation)
- 🐛 Reporting bugs via [GitHub Issues](https://github.com/Muslims-Community/prayer-times-calculation-dart/issues)
- 💡 Suggesting features
- 🔄 Contributing code

## 📞 Contact

- **Author**: Mahmoud Alsamman
- **Email**: memoibraheem1@gmail.com
- **GitHub**: [@mahmoudalsaman](https://github.com/mahmoudalsaman)
- **Package**: [prayer_times_calculation](https://pub.dev/packages/prayer_times_calculation)

---

<div align="center">

**Made with ❤️ for the Muslim community worldwide**

[![Follow on GitHub](https://img.shields.io/github/followers/mahmoudalsaman.svg?style=social&label=Follow)](https://github.com/mahmoudalsaman)

</div>