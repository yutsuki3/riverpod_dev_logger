/// Context information about the provider that emitted the log.
class ProviderContext {
  /// The name of the provider.
  final String providerName;

  /// The type of the provider.
  final String providerType;

  /// List of dependency names for the provider.
  final List<String>? dependencies;

  /// Additional extra metadata specific to the provider context.
  final Map<String, dynamic>? extra;

  /// Creates a [ProviderContext].
  const ProviderContext({
    required this.providerName,
    required this.providerType,
    this.dependencies,
    this.extra,
  });

  @override
  String toString() =>
      'ProviderContext(name: $providerName, type: $providerType, dependencies: $dependencies, extra: $extra)';
}
