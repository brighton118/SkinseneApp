import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/assessment_state.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rec = AssessmentState.instance.recommendationResult;

    if (rec == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recommendations')),
        body: const Center(child: Text('No recommendations available. Please start over.')),
      );
    }

    final draft = rec.draft;
    final action = draft.recommendedAction;
    
    // Select color based on guidance level
    Color severityColor = Colors.grey;
    final gl = rec.guidanceLevel.toLowerCase();
    if (gl.contains('emergency')) { severityColor = Colors.red; }
    else if (gl.contains('doctor') || gl.contains('urgent')) { severityColor = Colors.orange; }
    else if (gl.contains('consult')) { severityColor = Colors.amber; }
    else { severityColor = Colors.green; }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Care Plan'),
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
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildSectionCard(
              context,
              'Guidance Level',
              rec.guidanceLevel.toUpperCase(),
              severityColor,
              Icons.health_and_safety_rounded,
            ),
            const SizedBox(height: 32),
            _buildHeading(context, 'Explanation'),
            Text(
              draft.explanation, 
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            
            if (action.steps.isNotEmpty) ...[
              const SizedBox(height: 32),
              _buildHeading(context, 'Recommended Steps'),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: action.steps.map((step) => ListTile(
                      leading: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                      title: Text(step, style: const TextStyle(height: 1.4)),
                    )).toList(),
                  ),
                ),
              ),
            ],

            if (draft.prevention.isNotEmpty) ...[
              const SizedBox(height: 32),
              _buildHeading(context, 'Prevention'),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: draft.prevention.map((step) => ListTile(
                      leading: const Icon(Icons.shield_rounded, color: Colors.blueGrey),
                      title: Text(step, style: const TextStyle(height: 1.4)),
                    )).toList(),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    rec.disclaimer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                AssessmentState.instance.resetAssessment();
                context.go('/');
              },
              child: const Text('Finish Assessment', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      ),
    );

  }

  Widget _buildHeading(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value, 
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
