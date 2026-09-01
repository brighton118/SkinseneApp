// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/assessment_status_response.dart';
import '../models/image_assessment_result.dart';
import '../models/questionnaire.dart';
import '../models/questionnaire_response.dart';
import '../models/recommendation_result.dart';
import 'api_exception.dart';

class ApiService {
  static const String baseUrl = 'https://skinsense-backend-240757536793.us-central1.run.app';
  static const Duration timeoutDuration = Duration(seconds: 45); // Adjust as needed since LLMs can take time.

  final http.Client _client = http.Client();

  /// Validates response and throws ApiException if not successful.
  void _handleErrorResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    
    String message = 'Unexpected error occurred.';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('detail')) {
          message = decoded['detail'].toString();
        } else if (decoded.containsKey('message')) {
          message = decoded['message'].toString();
        }
      }
    } catch (_) {
      message = response.body.isNotEmpty ? response.body : 'Server responded with status ${response.statusCode}';
    }

    throw ApiException(
      message,
      statusCode: response.statusCode,
      endpoint: response.request?.url.path,
    );
  }
  
  void _handleStreamedErrorResponse(http.StreamedResponse response, String body) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    
    String message = 'Unexpected error occurred.';
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('detail')) {
          message = decoded['detail'].toString();
        }
      }
    } catch (_) {
      message = body.isNotEmpty ? body : 'Server responded with status ${response.statusCode}';
    }

    throw ApiException(
      message,
      statusCode: response.statusCode,
      endpoint: response.request?.url.path,
    );
  }

  /// Create a new assessment session
  Future<AssessmentStatusResponse> createAssessment() async {
    final sw = Stopwatch()..start();
    try {
      print('[ApiService] START createAssessment');
      final response = await _client.post(
        Uri.parse('$baseUrl/v1/assessments'),
      ).timeout(timeoutDuration);

      sw.stop();
      print('[ApiService] DONE createAssessment | ${response.statusCode} | ${sw.elapsedMilliseconds}ms');

      _handleErrorResponse(response);
      
      final data = jsonDecode(response.body);
      return AssessmentStatusResponse.fromJson(data);
      
    } on TimeoutException {
      throw ApiException('Connection timed out. Please check your internet connection.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to start assessment: $e');
    }
  }

  /// Upload the image.
  Future<ImageAssessmentResult> uploadImage(String assessmentId, String imagePath) async {
    final sw = Stopwatch()..start();
    try {
      print('[ApiService] START uploadImage | args: \$assessmentId');
      final uri = Uri.parse('$baseUrl/v1/assessments/$assessmentId/image-assessment');
      var request = http.MultipartRequest('POST', uri);
      
      request.files.add(
        await http.MultipartFile.fromPath('image', imagePath),
      );

      final streamedResponse = await _client.send(request).timeout(timeoutDuration);
      final responseBody = await streamedResponse.stream.bytesToString();
      
      sw.stop();
      print('[ApiService] DONE uploadImage | ${streamedResponse.statusCode} | ${sw.elapsedMilliseconds}ms');

      _handleStreamedErrorResponse(streamedResponse, responseBody);

      final data = jsonDecode(responseBody);
      return ImageAssessmentResult.fromJson(data);
      
    } on TimeoutException {
      throw ApiException('Image upload timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Failed to upload image.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to upload image: $e');
    }
  }

  /// Submit questionnaire
  Future<QuestionnaireResponse> saveQuestionnaire(String assessmentId, Questionnaire questionnaire) async {
    final sw = Stopwatch()..start();
    try {
      print('[ApiService] START saveQuestionnaire | args: \$assessmentId');
      final response = await _client.put(
        Uri.parse('$baseUrl/v1/assessments/$assessmentId/questionnaire'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(questionnaire.toJson()),
      ).timeout(timeoutDuration);

      sw.stop();
      print('[ApiService] DONE saveQuestionnaire | ${response.statusCode} | ${sw.elapsedMilliseconds}ms');

      _handleErrorResponse(response);

      final data = jsonDecode(response.body);
      return QuestionnaireResponse.fromJson(data);
      
    } on TimeoutException {
      throw ApiException('Saving questionnaire timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to save questionnaire: $e');
    }
  }

  /// Get recommendation result
  Future<RecommendationResult> getRecommendation(String assessmentId) async {
    final sw = Stopwatch()..start();
    try {
      print('[ApiService] START getRecommendation | args: \$assessmentId');
      final response = await _client.post(
        Uri.parse('$baseUrl/v1/assessments/$assessmentId/recommendation'),
      ).timeout(timeoutDuration);
      
      sw.stop();
      print('[ApiService] DONE getRecommendation | ${response.statusCode} | ${sw.elapsedMilliseconds}ms');

      _handleErrorResponse(response);

      final data = jsonDecode(response.body);
      return RecommendationResult.fromJson(data);
      
    } on TimeoutException {
      throw ApiException('Generating recommendations timed out. The AI might be taking a little longer.');
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to generate recommendation: $e');
    }
  }
}
