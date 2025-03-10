// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feederEdfSignalHash() => r'b7a0889c69ce7ed929d656ef9c541930b8529bd8';

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

abstract class _$FeederEdfSignal extends BuildlessNotifier<List<Offset>> {
  late final String edfFilePath;
  late final int start;

  List<Offset> build({
    required String edfFilePath,
    int start = 0,
  });
}

/// See also [FeederEdfSignal].
@ProviderFor(FeederEdfSignal)
const feederEdfSignalProvider = FeederEdfSignalFamily();

/// See also [FeederEdfSignal].
class FeederEdfSignalFamily extends Family<List<Offset>> {
  /// See also [FeederEdfSignal].
  const FeederEdfSignalFamily();

  /// See also [FeederEdfSignal].
  FeederEdfSignalProvider call({
    required String edfFilePath,
    int start = 0,
  }) {
    return FeederEdfSignalProvider(
      edfFilePath: edfFilePath,
      start: start,
    );
  }

  @override
  FeederEdfSignalProvider getProviderOverride(
    covariant FeederEdfSignalProvider provider,
  ) {
    return call(
      edfFilePath: provider.edfFilePath,
      start: provider.start,
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
  String? get name => r'feederEdfSignalProvider';
}

/// See also [FeederEdfSignal].
class FeederEdfSignalProvider
    extends NotifierProviderImpl<FeederEdfSignal, List<Offset>> {
  /// See also [FeederEdfSignal].
  FeederEdfSignalProvider({
    required String edfFilePath,
    int start = 0,
  }) : this._internal(
          () => FeederEdfSignal()
            ..edfFilePath = edfFilePath
            ..start = start,
          from: feederEdfSignalProvider,
          name: r'feederEdfSignalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feederEdfSignalHash,
          dependencies: FeederEdfSignalFamily._dependencies,
          allTransitiveDependencies:
              FeederEdfSignalFamily._allTransitiveDependencies,
          edfFilePath: edfFilePath,
          start: start,
        );

  FeederEdfSignalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.edfFilePath,
    required this.start,
  }) : super.internal();

  final String edfFilePath;
  final int start;

  @override
  List<Offset> runNotifierBuild(
    covariant FeederEdfSignal notifier,
  ) {
    return notifier.build(
      edfFilePath: edfFilePath,
      start: start,
    );
  }

  @override
  Override overrideWith(FeederEdfSignal Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeederEdfSignalProvider._internal(
        () => create()
          ..edfFilePath = edfFilePath
          ..start = start,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        edfFilePath: edfFilePath,
        start: start,
      ),
    );
  }

  @override
  NotifierProviderElement<FeederEdfSignal, List<Offset>> createElement() {
    return _FeederEdfSignalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeederEdfSignalProvider &&
        other.edfFilePath == edfFilePath &&
        other.start == start;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, edfFilePath.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeederEdfSignalRef on NotifierProviderRef<List<Offset>> {
  /// The parameter `edfFilePath` of this provider.
  String get edfFilePath;

  /// The parameter `start` of this provider.
  int get start;
}

class _FeederEdfSignalProviderElement
    extends NotifierProviderElement<FeederEdfSignal, List<Offset>>
    with FeederEdfSignalRef {
  _FeederEdfSignalProviderElement(super.provider);

  @override
  String get edfFilePath => (origin as FeederEdfSignalProvider).edfFilePath;
  @override
  int get start => (origin as FeederEdfSignalProvider).start;
}

String _$feederSignalHash() => r'3192f9603151f40bda1f9e2fa827154350bb7891';

abstract class _$FeederSignal
    extends BuildlessAutoDisposeStreamNotifier<List<Offset>> {
  late final String? id;

  Stream<List<Offset>> build({
    required String? id,
  });
}

/// See also [FeederSignal].
@ProviderFor(FeederSignal)
const feederSignalProvider = FeederSignalFamily();

/// See also [FeederSignal].
class FeederSignalFamily extends Family<AsyncValue<List<Offset>>> {
  /// See also [FeederSignal].
  const FeederSignalFamily();

  /// See also [FeederSignal].
  FeederSignalProvider call({
    required String? id,
  }) {
    return FeederSignalProvider(
      id: id,
    );
  }

  @override
  FeederSignalProvider getProviderOverride(
    covariant FeederSignalProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'feederSignalProvider';
}

/// See also [FeederSignal].
class FeederSignalProvider
    extends AutoDisposeStreamNotifierProviderImpl<FeederSignal, List<Offset>> {
  /// See also [FeederSignal].
  FeederSignalProvider({
    required String? id,
  }) : this._internal(
          () => FeederSignal()..id = id,
          from: feederSignalProvider,
          name: r'feederSignalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feederSignalHash,
          dependencies: FeederSignalFamily._dependencies,
          allTransitiveDependencies:
              FeederSignalFamily._allTransitiveDependencies,
          id: id,
        );

  FeederSignalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String? id;

  @override
  Stream<List<Offset>> runNotifierBuild(
    covariant FeederSignal notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(FeederSignal Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeederSignalProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<FeederSignal, List<Offset>>
      createElement() {
    return _FeederSignalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeederSignalProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeederSignalRef on AutoDisposeStreamNotifierProviderRef<List<Offset>> {
  /// The parameter `id` of this provider.
  String? get id;
}

class _FeederSignalProviderElement
    extends AutoDisposeStreamNotifierProviderElement<FeederSignal, List<Offset>>
    with FeederSignalRef {
  _FeederSignalProviderElement(super.provider);

  @override
  String? get id => (origin as FeederSignalProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
