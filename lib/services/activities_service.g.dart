// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activitiesService)
const activitiesServiceProvider = ActivitiesServiceProvider._();

final class ActivitiesServiceProvider
    extends
        $FunctionalProvider<
          ActivitiesService,
          ActivitiesService,
          ActivitiesService
        >
    with $Provider<ActivitiesService> {
  const ActivitiesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activitiesServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activitiesServiceHash();

  @$internal
  @override
  $ProviderElement<ActivitiesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivitiesService create(Ref ref) {
    return activitiesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivitiesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivitiesService>(value),
    );
  }
}

String _$activitiesServiceHash() => r'7816b272777a559a61107f44f1536e011fe3ee72';

@ProviderFor(activitiesStream)
const activitiesStreamProvider = ActivitiesStreamProvider._();

final class ActivitiesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Activity>>,
          List<Activity>,
          Stream<List<Activity>>
        >
    with $FutureModifier<List<Activity>>, $StreamProvider<List<Activity>> {
  const ActivitiesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activitiesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activitiesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Activity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Activity>> create(Ref ref) {
    return activitiesStream(ref);
  }
}

String _$activitiesStreamHash() => r'20f1fe8f87f4cc42cc265dab58e2f0f75b64d255';
