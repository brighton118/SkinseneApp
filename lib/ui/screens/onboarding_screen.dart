import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsense_africa_mobile/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // We use ? just in case localizations aren't fully loaded, though typically they are.
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildSlide(
                    context,
                    icon: Icons.camera_alt_rounded,
                    title: l10n?.onboardingPrepTitle ?? 'How to Take a Good Photo',
                    description: l10n?.onboardingPrepDesc ?? 'Find a well-lit area. Ensure the affected skin is clear, in focus, and centered in the frame.',
                  ),
                  _buildSlide(
                    context,
                    icon: Icons.auto_awesome_rounded,
                    title: l10n?.onboardingWelcomeTitle ?? 'Welcome to SkinSense',
                    description: l10n?.onboardingWelcomeDesc ?? 'Your AI-powered tool for early skin condition detection and guidance across Africa.',
                  ),
                  _buildSlide(
                    context,
                    icon: Icons.shield_rounded,
                    title: l10n?.onboardingSafetyTitle ?? 'Your Privacy Matters',
                    description: l10n?.onboardingSafetyDesc ?? 'Images are temporarily analyzed and never stored permanently without your consent.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    button: true,
                    label: 'Skip onboarding',
                    child: TextButton(
                      onPressed: () => context.go('/introduction'),
                      child: Text(l10n?.skipButton ?? 'Skip'),
                    ),
                  ),
                  Row(
                    children: List.generate(3, (index) => 
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: _currentPage == 2 ? 'Start Assessment' : 'Next slide',
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        } else {
                          context.go('/introduction');
                        }
                      },
                      child: Text(_currentPage == 2 ? (l10n?.startButton ?? 'Start') : (l10n?.nextButton ?? 'Next')),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(BuildContext context, {required IconData icon, required String title, required String description}) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Slide with title $title and description $description',
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 120, color: theme.colorScheme.primary),
            const SizedBox(height: 48),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              description,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
