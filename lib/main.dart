import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasktracker/providers/auth.dart';
import 'package:tasktracker/screens/home.dart';
import 'package:tasktracker/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      title: 'TaskTracker',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: switch (authState) {
        AsyncData(:final value) => value.session != null ? const HomePage() : const LoginPage(),
        AsyncError(:final error) => Scaffold(body: Center(child: Text('Erro: $error'))),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
      },
    );
  }

}
