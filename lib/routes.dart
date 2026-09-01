import 'package:go_router/go_router.dart';

import 'ui/screens/splash_screen.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/introduction_screen.dart';
import 'ui/screens/start_assessment_screen.dart';
import 'ui/screens/camera_screen.dart';
import 'ui/screens/image_preview_screen.dart';
import 'ui/screens/analysis_loading_screen.dart';
import 'ui/screens/questionnaire_screen.dart';
import 'ui/screens/results_screen.dart';
import 'ui/screens/recommendations_screen.dart';
import 'ui/screens/emergency_alert_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/introduction',
      builder: (context, state) => const IntroductionScreen(),
    ),
    GoRoute(
      path: '/start_assessment',
      builder: (context, state) => const StartAssessmentScreen(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: '/image_preview',
      builder: (context, state) {
        final imagePath = state.extra as String?;
        return ImagePreviewScreen(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: '/analysis_loading',
      builder: (context, state) => const AnalysisLoadingScreen(),
    ),
    GoRoute(
      path: '/questionnaire',
      builder: (context, state) => const QuestionnaireScreen(),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/recommendations',
      builder: (context, state) => const RecommendationsScreen(),
    ),
    GoRoute(
      path: '/emergency_alert',
      builder: (context, state) => const EmergencyAlertScreen(),
    ),
  ],
);
