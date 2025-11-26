// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_details_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityHistory)
const activityHistoryProvider = ActivityHistoryFamily._();

final class ActivityHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimeEntry>>,
          List<TimeEntry>,
          FutureOr<List<TimeEntry>>
        >
    with $FutureModifier<List<TimeEntry>>, $FutureProvider<List<TimeEntry>> {
  const ActivityHistoryProvider._({
    required ActivityHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityHistoryHash();

  @override
  String toString() {
    return r'activityHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TimeEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TimeEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return activityHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityHistoryHash() => r'd8da4a993d3932aaa60891d256e698e22a3e6b78';

final class ActivityHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TimeEntry>>, String> {
  const ActivityHistoryFamily._()
    : super(
        retry: null,
        name: r'activityHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityHistoryProvider call(String activityId) =>
      ActivityHistoryProvider._(argument: activityId, from: this);

  @override
  String toString() => r'activityHistoryProvider';
}
