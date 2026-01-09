import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasktracker/screens/home_screen.dart';
import 'package:tasktracker/screens/login_screen.dart';
import 'package:tasktracker/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['https://gvuemflbepmfvtqdydkz.supabase.co'] ?? '',
    anonKey: dotenv.env['eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2dWVtZmxiZXBtZnZ0cWR5ZGt6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3Mzk2NzUsImV4cCI6MjA3OTMxNTY3NX0.DO4GCx7Ju-dblEtGgdEXJtCCropcF3mM8elR_kB-T-c'] ?? '',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: authStateAsync.when(
        data: (authState) {
          if (authState.session != null) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}
