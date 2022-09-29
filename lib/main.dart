import 'package:cantique/screens/admin_home_page.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cantique',
      debugShowCheckedModeBanner: false,
      theme: AppStyles.themeData(false, context),
      darkTheme: AppStyles.themeData(true, context),
      home: const AdminHomePage(),
    );
  }
}
