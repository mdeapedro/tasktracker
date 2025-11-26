import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasktracker/models/activity.dart';
import 'package:tasktracker/models/time_entry.dart';

part 'activity_details_screen.g.dart';

@riverpod
Future<List<TimeEntry>> activityHistory(Ref ref, String activityId) async {
  final supabase = Supabase.instance.client;
  final data = await supabase
      .from('time_entries')
      .select()
      .eq('activity_id', activityId)
      .order('start_time', ascending: false);

  return data.map((json) => TimeEntry.fromJson(json)).toList();
}

class ActivityDetailsScreen extends ConsumerWidget {
  final Activity activity;

  const ActivityDetailsScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(activityHistoryProvider(activity.id));

    return Scaffold(
      appBar: AppBar(title: Text(activity.name)),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(child: Text('No history yet.'));
          }

          final totalSeconds = history.fold<int>(
            0,
            (sum, entry) => sum + entry.durationSeconds,
          );
          final totalDuration = Duration(seconds: totalSeconds);
          final totalHours = totalDuration.inHours;
          final totalMinutes = totalDuration.inMinutes % 60;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Time: ${totalHours}h ${totalMinutes}m',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    final duration = Duration(seconds: entry.durationSeconds);
                    final hours = duration.inHours;
                    final minutes = duration.inMinutes % 60;
                    final seconds = duration.inSeconds % 60;

                    return ListTile(
                      title: Text(
                        DateFormat.yMMMd().add_jm().format(entry.startTime),
                      ),
                      subtitle: entry.endTime == null
                          ? const Text(
                              'Running...',
                              style: TextStyle(color: Colors.green),
                            )
                          : Text('Duration: ${hours}h ${minutes}m ${seconds}s'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
