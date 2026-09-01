import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skinsense_africa_mobile/l10n/app_localizations.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    return true; // Prevents the raw stacktrace from breaking the native container
  };
  runApp(const SkinSenseAfricaApp());
}

class SkinSenseAfricaApp extends StatelessWidget {
  const SkinSenseAfricaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SkinSense Africa',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('sw'), // Swahili
        Locale('fr'), // French
      ],
    );
  }
}
