import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../features/update/mandatory_update_gate.dart';
import '../features/webview/client_portal_screen.dart';

class TilottomaaApp extends StatelessWidget {
  const TilottomaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.brandColor),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MandatoryUpdateGate(child: ClientPortalScreen()),
    );
  }
}
