import 'package:cantique/controllers/settings_controller.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    return MaterialApp(
      title: 'Cantique',
      debugShowCheckedModeBanner: false,
      theme: AppStyles.themeData(ref.watch(darkProvider), context),
      darkTheme: AppStyles.themeData(true, context),
      home: const HomePage(),
    );
  }
}
