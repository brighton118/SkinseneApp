// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'SkinSense Africa';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur SkinSense';

  @override
  String get onboardingWelcomeDesc =>
      'Votre outil intelligent pour la détection précoce des problèmes de peau en Afrique.';

  @override
  String get onboardingPrepTitle => 'Comment prendre une bonne photo';

  @override
  String get onboardingPrepDesc =>
      'Trouvez un endroit bien éclairé. Assurez-vous que la peau affectée est nette et centrée.';

  @override
  String get onboardingSafetyTitle => 'Votre vie privée compte';

  @override
  String get onboardingSafetyDesc =>
      'Les images sont analysées temporairement et ne sont jamais stockées sans votre consentement.';

  @override
  String get startButton => 'Commencer l\'évaluation';

  @override
  String get nextButton => 'Suivant';

  @override
  String get skipButton => 'Passer';

  @override
  String get retryButton => 'Réessayer';
}
