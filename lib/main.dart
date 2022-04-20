import 'package:bayad_sms_station/error.dart';
import 'package:bayad_sms_station/home.dart';
import 'package:bayad_sms_station/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final firebaseInitializatipnProvider = FutureProvider<FirebaseApp>((ref) {
  return Firebase.initializeApp();
});

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialization = ref.watch(firebaseInitializatipnProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Removes debug banner
      title: 'Bayad Matthew',
      theme: bayadDarkTheme(context),
      home: initialization.when(
        data: (data) {
          return const SafeArea(child: HomeScreen());
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) =>
            ErrorScreen(e: error, trace: stackTrace, route: '/'),
      ),
    );
  }
}
