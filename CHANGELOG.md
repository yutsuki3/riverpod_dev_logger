# 0.0.9

- **Fixed Parameter Mapping Bug**: Resolved an issue where state values were incorrectly logged as "Instance of 'ProviderContainer'" in some Riverpod versions.
- Improved log message clarity for provider initialization and updates.

# 0.0.8

- **Final Analysis Score Optimization**: Resolved remaining naming lints and parameter mismatches to achieve a perfect 160/160 score on pub.dev.
- Aligned `ProviderObserver` parameter names with Riverpod 3.x expectations while maintaining polymorphic compatibility for 2.x.

# 0.0.7

- **Fixed Static Analysis Issues**: Removed explicit `ProviderBase` type dependencies to ensure a perfect 160/160 pub.dev score and compatibility across all Riverpod environments.
- Polished documentation and examples.

# 0.0.6

- **Optimized Pub.dev Score**: Expanded Riverpod dependency range to `'>=2.0.0 <4.0.0'` to support the latest versions and improve package health score.
- **Multi-Version Support**: Refactored `RiverpodLoggerObserver` to handle both Riverpod 2.x and 3.x API signatures simultaneously.
- Updated `meta` dependency to `^1.15.0`.

# 0.0.5

- **Downgraded to Riverpod 2.0+ support** for broader compatibility.
- Refactored `RiverpodLoggerObserver` to support Riverpod 2.x API signatures.

# 0.0.4

- Added comprehensive dartdoc documentation for all public APIs.
- Fixed formatting issues across the project.
- Enabled `public_member_api_docs` lint rule to ensure documentation quality.

# 0.0.3

- **Upgraded to Riverpod 3.1.0**.
- Refactored `RiverpodLoggerObserver` to support the new `ProviderObserver` API.
- Simplified dependencies (removed `riverpod_test`).
- Improved code quality and fixed lint issues.
- Updated documentation for Riverpod 3.0+ compatibility.

# 0.0.2

- Added **State Diff Tracking** support.
    - Automatic detection of state changes in `ProviderObserver`.
    - Deep comparison for `Map`, `List`, and `Set`.
    - Support for custom objects via `toJson()` (e.g., Freezed, Equatable).
    - Visual diff formatting in console.

# 0.0.1

- Initial release of `riverpod_dev_logger`.
- Automatic Provider context detection using Dart Zones.
- Integration with `ProviderObserver`.
- `Ref` extension for easy logging.
- Support for child loggers with extra context.
- Console formatter with structured output.
