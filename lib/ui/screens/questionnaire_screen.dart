import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../services/assessment_state.dart';
import '../../models/questionnaire.dart';
import '../widgets/network_error_bottom_sheet.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSubmitting = false;

  // Form states mapping to backend exact values
  String _affectedBodyArea = 'face_or_neck';
  String _ageGroup = 'adult';
  String _duration = 'less_than_one_week';
  double _painLevel = 0;
  String _itching = 'no';
  String _rapidlySpreading = 'no';
  String _fever = 'no';
  String _highFever = 'no';
  String _swelling = 'no';
  String _difficultyBreathing = 'no';
  String _lipTongueThroatSwelling = 'no';
  String _bleeding = 'no';
  String _blistering = 'no';
  String _openWound = 'no';
  String _eyeInvolvement = 'no';
  String _possibleInfection = 'no';
  String _recurrent = 'no';
  String _productUsed = '';

  final Map<String, String> _durationOptions = {
    'less_than_one_week': 'Less than 1 week',
    'one_to_four_weeks': '1 to 4 weeks',
    'one_to_six_months': '1 to 6 months',
    'more_than_six_months': 'More than 6 months',
    'unsure': 'Not sure',
  };

  final Map<String, String> _areaOptions = {
    'face_or_neck': 'Face or neck',
    'scalp': 'Scalp',
    'chest_or_back': 'Chest or back',
    'arms_or_hands': 'Arms or hands',
    'legs_or_feet': 'Legs or feet',
    'groin_or_skin_folds': 'Groin or skin folds',
    'other': 'Another area',
    'unsure': 'Not sure',
  };
  
  final Map<String, String> _ageOptions = {
    'infant': 'Infant',
    'child': 'Child',
    'adolescent': 'Adolescent',
    'adult': 'Adult',
    'older_adult': 'Older adult',
    'prefer_not_to_say': 'Prefer not to say',
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Assessment?'),
        content: const Text('Are you sure you want to exit? Your progress will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AssessmentState.instance.resetAssessment();
              context.go('/');
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _submitForm();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final assessmentId = AssessmentState.instance.currentAssessmentId;
    if (assessmentId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Missing Assessment Session. Please start over.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isSubmitting = false);
      }
      return;
    }

    final questionnaire = Questionnaire(
      duration: _duration,
      itching: _itching,
      painLevel: _painLevel.toInt(),
      rapidlySpreading: _rapidlySpreading,
      affectedBodyArea: _affectedBodyArea,
      fever: _fever,
      highFever: _highFever,
      swelling: _swelling,
      difficultyBreathing: _difficultyBreathing,
      lipTongueThroatSwelling: _lipTongueThroatSwelling,
      bleeding: _bleeding,
      blistering: _blistering,
      openWound: _openWound,
      eyeInvolvement: _eyeInvolvement,
      possibleInfection: _possibleInfection,
      ageGroup: _ageGroup,
      recurrent: _recurrent,
      currentProducts: _productUsed.isNotEmpty ? [_productUsed] : null,
    );

    try {
      final response = await ApiService().saveQuestionnaire(assessmentId, questionnaire);
      AssessmentState.instance.questionnaireResponse = response;

      if (mounted) {
        final perm = response.safety.recommendationPermission;
        if (perm == 'blocked' || perm == 'escalation_only' || response.safety.urgency == 'emergency') {
          context.go('/emergency_alert');
        } else {
          context.go('/analysis_loading');
        }
      }
    } catch (e) {
      if (mounted) {
        final retry = await NetworkErrorBottomSheet.show(context);
        if (retry == true && mounted) {
           setState(() => _isSubmitting = false);
          _submitForm();
        } else if (mounted) {
           setState(() => _isSubmitting = false);
        }
      }
    }
  }

  Widget _buildDropdown(String label, String value, Map<String, String> items, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          initialValue: items.containsKey(value) ? value : items.keys.first,
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildToggle(String label, String value, void Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'yes', label: Text('Yes')),
            ButtonSegment(value: 'no', label: Text('No')),
            ButtonSegment(value: 'unsure', label: Text('Not sure')),
          ],
          selected: {value},
          onSelectionChanged: (Set<String> newSelection) {
            onChanged(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, String value, void Function(bool?) onChanged, {bool isUrgent = false}) {
    return CheckboxListTile(
      title: Text(label, style: TextStyle(color: isUrgent ? Theme.of(context).colorScheme.error : null)),
      value: value == 'yes',
      onChanged: (bool? val) {
        onChanged(val);
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Step 1: Duration & Recurrence
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How long has this concern been present?', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            _buildDropdown('Duration', _duration, _durationOptions, (v) => setState(() => _duration = v!)),
            const SizedBox(height: 32),
            _buildToggle('Has it happened before?', _recurrent, (v) => setState(() => _recurrent = v)),
          ],
        ),
      ),
      // Step 2: Sensation & Pain
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How does the area feel?', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            _buildToggle('Is it itchy?', _itching, (v) => setState(() => _itching = v)),
            const SizedBox(height: 32),
            const Text('Pain level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              children: [
                const Text('0'),
                Expanded(
                  child: Slider(
                    value: _painLevel,
                    min: 0, max: 10, divisions: 10,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (v) => setState(() => _painLevel = v),
                  ),
                ),
                Text('${_painLevel.round()} (Severe)'),
              ],
            ),
          ],
        ),
      ),
      // Step 3: Changes
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Has it changed in any of these ways?', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            _buildCheckbox('Spreading quickly', _rapidlySpreading, (v) => setState(() => _rapidlySpreading = v == true ? 'yes' : 'no')),
            _buildCheckbox('Feverish', _fever, (v) => setState(() => _fever = v == true ? 'yes' : 'no')),
            _buildCheckbox('Swollen', _swelling, (v) => setState(() => _swelling = v == true ? 'yes' : 'no')),
            _buildCheckbox('Warm, tender, or pus', _possibleInfection, (v) => setState(() => _possibleInfection = v == true ? 'yes' : 'no')),
          ],
        ),
      ),
      // Step 4: Warning Signs
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Do any urgent warning signs apply?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 24),
            _buildCheckbox('Breathing difficulty', _difficultyBreathing, (v) => setState(() => _difficultyBreathing = v == true ? 'yes' : 'no'), isUrgent: true),
            _buildCheckbox('Lip, tongue, or throat swelling', _lipTongueThroatSwelling, (v) => setState(() => _lipTongueThroatSwelling = v == true ? 'yes' : 'no'), isUrgent: true),
            _buildCheckbox('High fever', _highFever, (v) => setState(() => _highFever = v == true ? 'yes' : 'no'), isUrgent: true),
            _buildCheckbox('Eye or eyelid involved', _eyeInvolvement, (v) => setState(() => _eyeInvolvement = v == true ? 'yes' : 'no'), isUrgent: true),
            _buildCheckbox('Extensive blistering', _blistering, (v) => setState(() => _blistering = v == true ? 'yes' : 'no'), isUrgent: true),
            _buildCheckbox('Significant bleeding', _bleeding, (v) => setState(() => _bleeding = v == true ? 'yes' : 'no'), isUrgent: true),
            _buildCheckbox('Open or raw wound', _openWound, (v) => setState(() => _openWound = v == true ? 'yes' : 'no'), isUrgent: true),
          ],
        ),
      ),
      // Step 5: Demographics & Context
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A little context for the recommendation', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            _buildDropdown('Main area', _affectedBodyArea, _areaOptions, (v) => setState(() => _affectedBodyArea = v!)),
            const SizedBox(height: 32),
            _buildDropdown('Age group', _ageGroup, _ageOptions, (v) => setState(() => _ageGroup = v!)),
            const SizedBox(height: 32),
            const Text('Product or treatment already used (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _productUsed,
              maxLength: 100,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. Cortisone cream'),
              onChanged: (v) => setState(() => _productUsed = v),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentPage + 1} of 5'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentPage > 0) {
              _prevPage();
            } else {
              _confirmExit(context);
            }
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentPage > 0) {
            _prevPage();
          } else {
            _confirmExit(context);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentPage + 1) / 5,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                color: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  children: pages,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : _prevPage,
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _nextPage,
                        child: _isSubmitting 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(_currentPage == 4 ? 'See guidance' : 'Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
