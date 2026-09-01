class SafetyResult {
  final String urgency;
  final List<String> redFlags;
  final String recommendationPermission;
  final String policyVersion;
  final String actionMessage;
  final Map<String, dynamic>? feedback; // Optional safety feedback details

  SafetyResult({
    required this.urgency,
    required this.redFlags,
    required this.recommendationPermission,
    required this.policyVersion,
    required this.actionMessage,
    this.feedback,
  });

  factory SafetyResult.fromJson(Map<String, dynamic> json) {
    return SafetyResult(
      urgency: json['urgency'] as String,
      redFlags: (json['red_flags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      recommendationPermission: json['recommendation_permission'] as String,
      policyVersion: json['policy_version'] as String,
      actionMessage: json['action_message'] as String,
      feedback: json['feedback'] as Map<String, dynamic>?,
    );
  }
}
