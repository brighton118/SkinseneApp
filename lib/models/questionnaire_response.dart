import 'safety_result.dart';

class QuestionnaireResponse {
  final String id;
  final String status;
  final SafetyResult safety;

  QuestionnaireResponse({
    required this.id,
    required this.status,
    required this.safety,
  });

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    return QuestionnaireResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      safety: SafetyResult.fromJson(json['safety'] as Map<String, dynamic>),
    );
  }
}
