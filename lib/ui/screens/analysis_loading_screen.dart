import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../services/api_service.dart';
import '../../services/assessment_state.dart';
import '../widgets/network_error_bottom_sheet.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  const AnalysisLoadingScreen({super.key});

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen> {
  int _messageIndex = 0;
  final List<String> _messages = [
    'Validating image quality',
    'Removing image metadata',
    'Reading visual patterns'
  ];
  Timer? _animTimer;
  bool _isUploading = false; // Prevent multiple calls

  @override
  void initState() {
    super.initState();
    _startMessageTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _uploadImageAndProceed();
    });
  }

  void _startMessageTimer() {
    _animTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });
  }

  Future<void> _uploadImageAndProceed() async {
    if (_isUploading) return;
    _isUploading = true;
    
    var future = AssessmentState.instance.imageUploadFuture;
    
    if (future == null) {
      final imagePath = AssessmentState.instance.imagePath;
      final assessmentId = AssessmentState.instance.currentAssessmentId;

      if (imagePath != null && assessmentId != null) {
        future = ApiService().uploadImage(assessmentId, imagePath);
        AssessmentState.instance.imageUploadFuture = future;
      }
    }

    if (future == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Missing assessment session. Please start over.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        AssessmentState.instance.resetAssessment();
        context.go('/');
      }
      return;
    }

    try {
      final result = await future;
      AssessmentState.instance.imageResult = result;
      
      if (mounted) {
        context.go('/results');
      }
    } catch (e) {
      if (mounted) {
        _handleUploadError();
      }
    }
  }

  Future<void> _handleUploadError() async {
    _isUploading = false;
    final retry = await NetworkErrorBottomSheet.show(context);
    if (retry == true && mounted) {
      // Regenerate the future
      final assessmentId = AssessmentState.instance.currentAssessmentId;
      final imagePath = AssessmentState.instance.imagePath;
      if (assessmentId != null && imagePath != null) {
        AssessmentState.instance.imageUploadFuture = ApiService().uploadImage(assessmentId, imagePath);
        _uploadImageAndProceed();
      }
    } else {
      if (mounted) {
        AssessmentState.instance.imageUploadFuture = null;
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulse Ring & Sparkles
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 1400),
                  curve: Curves.easeInOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.auto_awesome, // Sparkles
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Validating Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _messages[_messageIndex],
                    key: ValueKey<int>(_messageIndex),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
