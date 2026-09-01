import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/image_assessment_result.dart';
import '../models/questionnaire_response.dart';
import '../models/recommendation_result.dart';

/// Lightweight container for managing the current assessment flow state.
/// This acts as a centralized place to hold session data across screens 
/// but is strictly reset when a new assessment begins.
class AssessmentState extends ChangeNotifier {
  static final AssessmentState _instance = AssessmentState._internal();
  
  // Factory constructor to provide singleton instance
  factory AssessmentState() => _instance;
  
  // Private constructor
  AssessmentState._internal();

  /// Expose the underlying singleton instance
  static AssessmentState get instance => _instance;

  String? currentAssessmentId;
  String? imagePath;
  ImageAssessmentResult? imageResult;
  QuestionnaireResponse? questionnaireResponse;
  RecommendationResult? recommendationResult;
  Future<ImageAssessmentResult>? imageUploadFuture;

  /// Resets the assessment session back to default.
  /// Must be called before initiating a new assessment POST /v1/assessments
  void resetAssessment() {
    if (imagePath != null) {
      try {
        final f = File(imagePath!);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }
    currentAssessmentId = null;
    imagePath = null;
    imageResult = null;
    questionnaireResponse = null;
    recommendationResult = null;
    imageUploadFuture = null;
    notifyListeners();
  }
}
