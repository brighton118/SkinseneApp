import 'safety_result.dart';

class RecommendationDraft {
  final String explanation;
  final List<String> possibleContributingFactors;
  final List<String> skinToneConsiderations;
  final RecommendedAction recommendedAction;
  final List<String> prevention;
  final List<String> warningSigns;
  final List<String> limitations;

  RecommendationDraft({
    required this.explanation,
    required this.possibleContributingFactors,
    required this.skinToneConsiderations,
    required this.recommendedAction,
    required this.prevention,
    required this.warningSigns,
    required this.limitations,
  });

  factory RecommendationDraft.fromJson(Map<String, dynamic> json) {
    return RecommendationDraft(
      explanation: json['explanation'] as String,
      possibleContributingFactors: (json['possible_contributing_factors'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      skinToneConsiderations: (json['skin_tone_considerations'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      recommendedAction: RecommendedAction.fromJson(json['recommended_action'] as Map<String, dynamic>),
      prevention: (json['prevention'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      warningSigns: (json['warning_signs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      limitations: (json['limitations'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class RecommendedAction {
  final String type;
  final String urgency;
  final List<String> steps;
  final String? referralReason;

  RecommendedAction({
    required this.type,
    required this.urgency,
    required this.steps,
    this.referralReason,
  });

  factory RecommendedAction.fromJson(Map<String, dynamic> json) {
    return RecommendedAction(
      type: json['type'] as String,
      urgency: json['urgency'] as String,
      steps: (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      referralReason: json['referral_reason'] as String?,
    );
  }
}

class RecommendationResult {
  final String assessmentId;
  final String condition;
  final String confidenceLevel;
  final double? confidenceScore;
  final String guidanceLevel;
  final bool referralRequired;
  final SafetyResult safety;
  final String disclaimer;
  final RecommendationDraft draft;

  RecommendationResult({
    required this.assessmentId,
    required this.condition,
    required this.confidenceLevel,
    this.confidenceScore,
    required this.guidanceLevel,
    required this.referralRequired,
    required this.safety,
    required this.disclaimer,
    required this.draft,
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    return RecommendationResult(
      assessmentId: json['assessment_id'] as String,
      condition: json['condition'] as String,
      confidenceLevel: json['confidence_level'] as String,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      guidanceLevel: json['guidance_level'] as String,
      referralRequired: json['referral_required'] as bool? ?? false,
      safety: SafetyResult.fromJson(json['safety'] as Map<String, dynamic>),
      disclaimer: json['disclaimer'] as String,
      draft: RecommendationDraft.fromJson(json['draft'] as Map<String, dynamic>),
    );
  }
}
