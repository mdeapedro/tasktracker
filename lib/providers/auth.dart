import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth.g.dart';

@riverpod
SupabaseClient supabase(Ref ref) {
  return Supabase.instance.client;
}

@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
}

@riverpod
class AuthRepository extends _$AuthRepository {
  @override
  void build() {}

  Future<void> signInWithGoogle() async {
    final redirectTo = kIsWeb
        ? null
        : 'io.supabase.flutter://login-callback/';

    await ref.read(supabaseProvider).auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectTo,
    );
  }

  Future<void> signOut() async {
    await ref.read(supabaseProvider).auth.signOut();
  }
}
