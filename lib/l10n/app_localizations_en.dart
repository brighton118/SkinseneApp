// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SkinSense Africa';

  @override
  String get onboardingWelcomeTitle => 'Welcome to SkinSense';

  @override
  String get onboardingWelcomeDesc =>
      'Your AI-powered tool for early skin condition detection and guidance across Africa.';

  @override
  String get onboardingPrepTitle => 'How to Take a Good Photo';

  @override
  String get onboardingPrepDesc =>
      'Find a well-lit area. Ensure the affected skin is clear, in focus, and centered in the frame.';

  @override
  String get onboardingSafetyTitle => 'Your Privacy Matters';

  @override
  String get onboardingSafetyDesc =>
      'Images are temporarily analyzed and never stored permanently without your consent.';

  @override
  String get startButton => 'Start Assessment';

  @override
  String get nextButton => 'Next';

  @override
  String get skipButton => 'Skip';

  @override
  String get retryButton => 'Retry';
}
