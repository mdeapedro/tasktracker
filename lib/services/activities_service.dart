import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasktracker/models/activity.dart';

part 'activities_service.g.dart';

@Riverpod(keepAlive: true)
ActivitiesService activitiesService(Ref ref) {
  return ActivitiesService();
}

@riverpod
Stream<List<Activity>> activitiesStream(Ref ref) {
  final service = ref.watch(activitiesServiceProvider);
  return service.getActivitiesStream();
}

class ActivitiesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<Activity>> getActivitiesStream() {
    return _supabase
        .from('activities')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true)
        .map((data) => data.map((json) => Activity.fromJson(json)).toList());
  }

  Future<void> createActivity(String name) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.from('activities').insert({
      'user_id': user.id,
      'name': name,
    });
  }

  Future<void> updateActivity(String id, String name) async {
    await _supabase
        .from('activities')
        .update({'name': name, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  Future<void> deleteActivity(String id) async {
    await _supabase.from('activities').delete().eq('id', id);
  }
}
