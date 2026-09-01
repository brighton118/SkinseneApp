class AssessmentStatusResponse {
  final String id;
  final String status;

  AssessmentStatusResponse({
    required this.id,
    required this.status,
  });

  factory AssessmentStatusResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentStatusResponse(
      id: json['id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
}
