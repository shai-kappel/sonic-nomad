import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sonic_nomad/firebase_options.dart';
import 'package:sonic_nomad/app/di.dart';
import 'package:sonic_nomad/app/presentation/pages/app_shell_page.dart';
import 'package:sonic_nomad/core/config/app_config.dart';
import 'package:sonic_nomad/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppConfig.environment = Environment.dev;
  await initDependencies();
  runApp(const SonicNomadApp());
}

class SonicNomadApp extends StatelessWidget {
  const SonicNomadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AppShellPage(),
    );
  }
}
