import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../services/assessment_state.dart';
import '../../services/api_exception.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isLoading = false;

  Future<void> _fetchRecommendations() async {
    if (_isLoading) return;

    final id = AssessmentState.instance.currentAssessmentId;
    if (id == null) return;

    setState(() => _isLoading = true);
    
    try {
      final recs = await ApiService().getRecommendation(id);
      AssessmentState.instance.recommendationResult = recs;
      if (mounted) {
        context.go('/recommendations');
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageResult = AssessmentState.instance.imageResult;

    if (imageResult == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assessment Results')),
        body: const Center(child: Text('No results found. Please start over.')),
      );
    }

    final findings = imageResult.visualFindings.isNotEmpty 
      ? imageResult.visualFindings.join(', ') 
      : 'None detected';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            AssessmentState.instance.resetAssessment();
            context.go('/');
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          AssessmentState.instance.resetAssessment();
          context.go('/');
        },
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'AI Analysis Complete',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Condition Detected', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        (imageResult.condition ?? 'Uncertain').toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Icon(Icons.visibility_outlined, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Visual Findings', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        findings, 
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: _fetchRecommendations,
                    child: const Text('Generate Custom Recommendations', style: TextStyle(fontSize: 16)),
                  ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

