# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-01-20

### Fixed
- CHANGELOG.md format and dates for pub.dev compliance

## [1.0.1] - 2025-01-20

### Fixed
- Code formatting issues across all source files
- Lint issues: removed print statements from test files
- String interpolation warnings
- Pub.dev score improved from 40/50 to 50/50

### Changed
- Excluded example directory from avoid_print lint rule
- Updated analysis_options.yaml configuration

## [1.0.0] - 2025-01-20

### Added
- Initial release of Prayer Times Calculation SDK for Dart and Flutter
- Support for 6 calculation methods: MWL, ISNA, Egypt, Makkah, Karachi, Custom
- Support for both Standard and Hanafi Asr jurisdictions
- Complete astronomical calculations for prayer times
- Zero external dependencies
- Comprehensive test suite with 25+ test cases
- Performance optimization for <10ms calculation time
- Full null safety compliance
- Type-safe API with proper error handling
- Comprehensive documentation and examples
- Flutter widget integration examples
- Multi-platform support (CLI, Mobile, Web, Desktop)

### Features
- ✅ **Zero Dependencies**: No external packages required
- ✅ **Offline**: Works completely offline without internet connection
- ✅ **Fast**: Calculations complete in <10ms
- ✅ **Lightweight**: Minimal package size
- ✅ **Accurate**: ±1 minute accuracy compared to official sources
- ✅ **Flexible**: Support for multiple calculation methods and custom angles
- ✅ **Type Safe**: Full Dart type safety with null safety compliance
- ✅ **Universal**: Works in Dart CLI, Flutter mobile, web, and desktop apps
- ✅ **Well-tested**: Comprehensive test suite with 25+ test cases