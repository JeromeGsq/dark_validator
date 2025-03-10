// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edf_loader.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$edfFileLoaderHash() => r'c98e325d2f2bbb3499c0501e1cbedb2ca9c133ef';

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

abstract class _$EdfFileLoader
    extends BuildlessAutoDisposeAsyncNotifier<EdfData<Offset>?> {
  late final String? path;

  FutureOr<EdfData<Offset>?> build({
    required String? path,
  });
}

/// See also [EdfFileLoader].
@ProviderFor(EdfFileLoader)
const edfFileLoaderProvider = EdfFileLoaderFamily();

/// See also [EdfFileLoader].
class EdfFileLoaderFamily extends Family<AsyncValue<EdfData<Offset>?>> {
  /// See also [EdfFileLoader].
  const EdfFileLoaderFamily();

  /// See also [EdfFileLoader].
  EdfFileLoaderProvider call({
    required String? path,
  }) {
    return EdfFileLoaderProvider(
      path: path,
    );
  }

  @override
  EdfFileLoaderProvider getProviderOverride(
    covariant EdfFileLoaderProvider provider,
  ) {
    return call(
      path: provider.path,
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
  String? get name => r'edfFileLoaderProvider';
}

/// See also [EdfFileLoader].
class EdfFileLoaderProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EdfFileLoader, EdfData<Offset>?> {
  /// See also [EdfFileLoader].
  EdfFileLoaderProvider({
    required String? path,
  }) : this._internal(
          () => EdfFileLoader()..path = path,
          from: edfFileLoaderProvider,
          name: r'edfFileLoaderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$edfFileLoaderHash,
          dependencies: EdfFileLoaderFamily._dependencies,
          allTransitiveDependencies:
              EdfFileLoaderFamily._allTransitiveDependencies,
          path: path,
        );

  EdfFileLoaderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String? path;

  @override
  FutureOr<EdfData<Offset>?> runNotifierBuild(
    covariant EdfFileLoader notifier,
  ) {
    return notifier.build(
      path: path,
    );
  }

  @override
  Override overrideWith(EdfFileLoader Function() create) {
    return ProviderOverride(
      origin: this,
      override: EdfFileLoaderProvider._internal(
        () => create()..path = path,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EdfFileLoader, EdfData<Offset>?>
      createElement() {
    return _EdfFileLoaderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EdfFileLoaderProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EdfFileLoaderRef
    on AutoDisposeAsyncNotifierProviderRef<EdfData<Offset>?> {
  /// The parameter `path` of this provider.
  String? get path;
}

class _EdfFileLoaderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EdfFileLoader,
        EdfData<Offset>?> with EdfFileLoaderRef {
  _EdfFileLoaderProviderElement(super.provider);

  @override
  String? get path => (origin as EdfFileLoaderProvider).path;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
