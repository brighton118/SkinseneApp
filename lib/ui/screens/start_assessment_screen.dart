import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../services/assessment_state.dart';
import '../../services/api_exception.dart';
import '../widgets/error_state_widget.dart';

class StartAssessmentScreen extends StatefulWidget {
  const StartAssessmentScreen({super.key});

  @override
  State<StartAssessmentScreen> createState() => _StartAssessmentScreenState();
}

class _StartAssessmentScreenState extends State<StartAssessmentScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _startAssessment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Clean up previous assessment data completely
      AssessmentState.instance.resetAssessment();
      
      final apiService = ApiService();
      final response = await apiService.createAssessment();
      
      AssessmentState.instance.currentAssessmentId = response.id;
      
      if (mounted) {
        context.go('/camera');
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to connect to the backend server. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assessment')),
        body: ErrorStateWidget(
          message: _errorMessage!,
          onRetry: _startAssessment,
          onBack: () => context.go('/welcome'),
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Preparation')),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text('Initializing secure session...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'For the best analysis, please follow these instructions:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInstructionItem(Icons.light_mode, 'Use good lighting'),
                  _buildInstructionItem(Icons.cleaning_services, 'Clean the camera lens'),
                  _buildInstructionItem(Icons.crop_free, 'Keep the affected area clearly visible in the center'),
                  _buildInstructionItem(Icons.filter_b_and_w, 'Avoid filters or heavy edits'),
                  _buildInstructionItem(Icons.pan_tool, 'Keep the camera steady'),
                  
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'SkinSense Africa provides AI-assisted information and does not replace professional medical diagnosis.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _startAssessment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Begin Assessment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
