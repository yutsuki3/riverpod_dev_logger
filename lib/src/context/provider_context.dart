class ProviderContext {
  final String providerName;
  final String providerType;
  final List<String>? dependencies;
  final Map<String, dynamic>? extra;

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
