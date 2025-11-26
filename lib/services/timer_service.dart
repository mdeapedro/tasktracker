import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasktracker/models/time_entry.dart';

part 'timer_service.g.dart';

@Riverpod(keepAlive: true)
TimerService timerService(Ref ref) {
  return TimerService();
}

@riverpod
Stream<TimeEntry?> activeTimer(Ref ref) {
  final service = ref.watch(timerServiceProvider);
  return service.getActiveTimerStream();
}

class TimerService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<TimeEntry?> getActiveTimerStream() {
    return _supabase.from('time_entries').stream(primaryKey: ['id']).map((data) {
      final activeEntries = data
          .where((json) => json['end_time'] == null)
          .toList();
      if (activeEntries.isEmpty) return null;
      return TimeEntry.fromJson(activeEntries.first);
    });
  }

  Future<void> startTimer(String activityId) async {
    final activeTimer = await _supabase
        .from('time_entries')
        .select()
        .filter('end_time', 'is', null)
        .maybeSingle();

    if (activeTimer != null) {
      await stopTimer(activeTimer['id']);
    }

    await _supabase.from('time_entries').insert({
      'activity_id': activityId,
      'start_time': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> stopTimer(String timeEntryId) async {
    final endTime = DateTime.now().toUtc();

    final data = await _supabase
        .from('time_entries')
        .select('start_time')
        .eq('id', timeEntryId)
        .single();

    final startTime = DateTime.parse(data['start_time']);
    final duration = endTime.difference(startTime).inSeconds;

    await _supabase
        .from('time_entries')
        .update({
          'end_time': endTime.toIso8601String(),
          'duration_seconds': duration,
        })
        .eq('id', timeEntryId);
  }
}
