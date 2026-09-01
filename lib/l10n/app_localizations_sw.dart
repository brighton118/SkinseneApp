// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'SkinSense Africa';

  @override
  String get onboardingWelcomeTitle => 'Karibu SkinSense';

  @override
  String get onboardingWelcomeDesc =>
      'Zana yako inayotumia AI kwa ugunduzi wa mapema wa magonjwa ya ngozi kote Afrika.';

  @override
  String get onboardingPrepTitle => 'Jinsi ya Kupiga Picha Nzuri';

  @override
  String get onboardingPrepDesc =>
      'Tafuta eneo lenye mwanga. Hakikisha ngozi iliyoathirika inaonekana wazi na ipo katikati ya picha.';

  @override
  String get onboardingSafetyTitle => 'Faragha Yako Ni Muhimu';

  @override
  String get onboardingSafetyDesc =>
      'Picha huchunguzwa kwa muda na hazihifadhiwi kabisa bila idhini yako.';

  @override
  String get startButton => 'Anza Upimaji';

  @override
  String get nextButton => 'Endelea';

  @override
  String get skipButton => 'Ruka';

  @override
  String get retryButton => 'Jaribu Tena';
}
