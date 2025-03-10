// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$algoSignalHash() => r'6a98f52a37e7fde84881f581bd72ebe34bfbec03';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AlgoSignal extends BuildlessNotifier<List<Offset>> {
  late final String id;
  late final int bufferSize;

  List<Offset> build({
    required String id,
    int bufferSize = 50,
  });
}

/// See also [AlgoSignal].
@ProviderFor(AlgoSignal)
const algoSignalProvider = AlgoSignalFamily();

/// See also [AlgoSignal].
class AlgoSignalFamily extends Family<List<Offset>> {
  /// See also [AlgoSignal].
  const AlgoSignalFamily();

  /// See also [AlgoSignal].
  AlgoSignalProvider call({
    required String id,
    int bufferSize = 50,
  }) {
    return AlgoSignalProvider(
      id: id,
      bufferSize: bufferSize,
    );
  }

  @override
  AlgoSignalProvider getProviderOverride(
    covariant AlgoSignalProvider provider,
  ) {
    return call(
      id: provider.id,
      bufferSize: provider.bufferSize,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'algoSignalProvider';
}

/// See also [AlgoSignal].
class AlgoSignalProvider
    extends NotifierProviderImpl<AlgoSignal, List<Offset>> {
  /// See also [AlgoSignal].
  AlgoSignalProvider({
    required String id,
    int bufferSize = 50,
  }) : this._internal(
          () => AlgoSignal()
            ..id = id
            ..bufferSize = bufferSize,
          from: algoSignalProvider,
          name: r'algoSignalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$algoSignalHash,
          dependencies: AlgoSignalFamily._dependencies,
          allTransitiveDependencies:
              AlgoSignalFamily._allTransitiveDependencies,
          id: id,
          bufferSize: bufferSize,
        );

  AlgoSignalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.bufferSize,
  }) : super.internal();

  final String id;
  final int bufferSize;

  @override
  List<Offset> runNotifierBuild(
    covariant AlgoSignal notifier,
  ) {
    return notifier.build(
      id: id,
      bufferSize: bufferSize,
    );
  }

  @override
  Override overrideWith(AlgoSignal Function() create) {
    return ProviderOverride(
      origin: this,
      override: AlgoSignalProvider._internal(
        () => create()
          ..id = id
          ..bufferSize = bufferSize,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        bufferSize: bufferSize,
      ),
    );
  }

  @override
  NotifierProviderElement<AlgoSignal, List<Offset>> createElement() {
    return _AlgoSignalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlgoSignalProvider &&
        other.id == id &&
        other.bufferSize == bufferSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, bufferSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AlgoSignalRef on NotifierProviderRef<List<Offset>> {
  /// The parameter `id` of this provider.
  String get id;

  /// The parameter `bufferSize` of this provider.
  int get bufferSize;
}

class _AlgoSignalProviderElement
    extends NotifierProviderElement<AlgoSignal, List<Offset>>
    with AlgoSignalRef {
  _AlgoSignalProviderElement(super.provider);

  @override
  String get id => (origin as AlgoSignalProvider).id;
  @override
  int get bufferSize => (origin as AlgoSignalProvider).bufferSize;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
