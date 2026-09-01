class ImageAssessmentResult {
  final String assessmentStatus;
  final String? condition;
  final String? confidenceLevel;
  final double? confidenceScore;
  final List<String> visualFindings;
  final List<String> alternativeConditions;
  final bool needsMoreInformation;
  final List<String> followUpQuestionIds;
  final List<String> visualSafetySignals;
  final String recommendationStatus;

  ImageAssessmentResult({
    required this.assessmentStatus,
    this.condition,
    this.confidenceLevel,
    this.confidenceScore,
    required this.visualFindings,
    required this.alternativeConditions,
    required this.needsMoreInformation,
    required this.followUpQuestionIds,
    required this.visualSafetySignals,
    required this.recommendationStatus,
  });

  factory ImageAssessmentResult.fromJson(Map<String, dynamic> json) {
    return ImageAssessmentResult(
      assessmentStatus: json['assessment_status'] as String,
      condition: json['condition'] as String?,
      confidenceLevel: json['confidence_level'] as String?,
      // Handle int or double safely
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      visualFindings: (json['visual_findings'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      alternativeConditions: (json['alternative_conditions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      needsMoreInformation: json['needs_more_information'] as bool? ?? false,
      followUpQuestionIds: (json['follow_up_question_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      visualSafetySignals: (json['visual_safety_signals'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      recommendationStatus: json['recommendation_status'] as String,
    );
  }
}
