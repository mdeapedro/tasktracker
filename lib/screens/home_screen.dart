import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasktracker/models/activity.dart';
import 'package:tasktracker/services/activities_service.dart';
import 'package:tasktracker/screens/activity_details_screen.dart';
import 'package:tasktracker/services/auth_service.dart';
import 'package:tasktracker/services/timer_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final activitiesAsync = ref.watch(activitiesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: activitiesAsync.when(
        data: (activities) {
          if (activities.isEmpty) {
            return const Center(child: Text('No activities yet. Create one!'));
          }
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ActivityTile(activity: activity);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateActivityDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateActivityDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Activity'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Activity Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                try {
                  await ref
                      .read(activitiesServiceProvider)
                      .createActivity(name);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class ActivityTile extends ConsumerWidget {
  final Activity activity;

  const ActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTimerAsync = ref.watch(activeTimerProvider);

    return activeTimerAsync.when(
      data: (activeTimer) {
        final isRunning = activeTimer?.activityId == activity.id;

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailsScreen(activity: activity),
              ),
            );
          },
          title: Text(activity.name),
          subtitle: isRunning
              ? _TimerTicker(startTime: activeTimer!.startTime)
              : const Text('Ready to start'), // TODO: Show total duration
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                color: isRunning ? Colors.red : Colors.green,
                onPressed: () async {
                  final timerService = ref.read(timerServiceProvider);
                  if (isRunning) {
                    await timerService.stopTimer(activeTimer!.id);
                  } else {
                    await timerService.startTimer(activity.id);
                  }
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit Name')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(context, ref, activity);
                  } else if (value == 'delete') {
                    _confirmDelete(context, ref, activity);
                  }
                },
              ),
            ],
          ),
        );
      },
      loading: () => const ListTile(title: Text('Loading...')),
      error: (e, st) => ListTile(title: Text('Error: $e')),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    final controller = TextEditingController(text: activity.name);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Activity'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Activity Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                try {
                  await ref
                      .read(activitiesServiceProvider)
                      .updateActivity(activity.id, name);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text(
          'Are you sure? This will delete all history permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(activitiesServiceProvider).deleteActivity(activity.id);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
}

class _TimerTicker extends StatefulWidget {
  final DateTime startTime;
  const _TimerTicker({required this.startTime});

  @override
  State<_TimerTicker> createState() => _TimerTickerState();
}

class _TimerTickerState extends State<_TimerTicker> {
  late Timer _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _updateDuration();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateDuration(),
    );
  }

  void _updateDuration() {
    setState(() {
      _duration = DateTime.now().difference(widget.startTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }
}
