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
