// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timerService)
const timerServiceProvider = TimerServiceProvider._();

final class TimerServiceProvider
    extends $FunctionalProvider<TimerService, TimerService, TimerService>
    with $Provider<TimerService> {
  const TimerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerServiceHash();

  @$internal
  @override
  $ProviderElement<TimerService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimerService create(Ref ref) {
    return timerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerService>(value),
    );
  }
}

String _$timerServiceHash() => r'99fe407445d976be962a6d6bc151f67fd4f3e08c';

@ProviderFor(activeTimer)
const activeTimerProvider = ActiveTimerProvider._();

final class ActiveTimerProvider
    extends
        $FunctionalProvider<
          AsyncValue<TimeEntry?>,
          TimeEntry?,
          Stream<TimeEntry?>
        >
    with $FutureModifier<TimeEntry?>, $StreamProvider<TimeEntry?> {
  const ActiveTimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTimerHash();

  @$internal
  @override
  $StreamProviderElement<TimeEntry?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<TimeEntry?> create(Ref ref) {
    return activeTimer(ref);
  }
}

String _$activeTimerHash() => r'6c617f67f99edd6fa95cfa4f5470813436a1d2fa';
