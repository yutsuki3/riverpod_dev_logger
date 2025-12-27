/// Severity levels for logs.
enum LogLevel {
  /// Fine-grained informational events that are most useful to debug an application.
  debug,

  /// Informational messages that highlight the progress of the application at coarse-grained level.
  info,

  /// Potentially harmful situations.
  warning,

  /// Error events that might still allow the application to continue running.
  error,
}
