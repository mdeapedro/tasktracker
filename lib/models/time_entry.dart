class TimeEntry {
  final String id;
  final String activityId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;

  TimeEntry({
    required this.id,
    required this.activityId,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      activityId: json['activity_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'])
          : null,
      durationSeconds: json['duration_seconds'] ?? 0,
    );
  }
}
