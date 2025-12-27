class ProviderContext {
  final String providerName;
  final List<String> dependencies;
  final String? mutation;

  const ProviderContext({
    required this.providerName,
    this.dependencies = const [],
    this.mutation,
  });

  @override
  String toString() {
    return 'ProviderContext(providerName: $providerName, dependencies: $dependencies, mutation: $mutation)';
  }
}
