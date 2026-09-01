// ignore_for_file: avoid_print, unused_local_variable, unused_import
import 'dart:io';
import 'package:http/http.dart' as http;
import 'lib/services/api_service.dart';
import 'lib/models/questionnaire.dart';

Future<void> main() async {
  print('--- Starting End-to-End API Verification ---');
  final api = ApiService();

  print('1. Creating Assessment...');
  final session = await api.createAssessment();
  print('Assessment ID: \${session.id}');
  print('Status: \${session.status}');
  
  if (session.id.isEmpty) {
    print('FAILED: Assessment ID is empty.');
    exit(1);
  }

  // Create a dummy image file.
  final tempFile = File('dummy_image.jpg');
  await tempFile.writeAsBytes([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01, 0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43, 0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09, 0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12, 0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C, 0x1C, 0x20, 0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29, 0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27, 0x39, 0x3D, 0x38, 0x32, 0x3C, 0x2E, 0x33, 0x34, 0x32, 0xFF, 0xC0, 0x00, 0x0B, 0x08, 0x00, 0x01, 0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0xFF, 0xDA, 0x00, 0x08, 0x01, 0x01, 0x00, 0x00, 0x3F, 0x00, 0xD2, 0xFF, 0xD9]); // Minimal valid JPEG

  try {
    print('\n2. Uploading Image...');
    final imageResult = await api.uploadImage(session.id, tempFile.path);
    print('Image Findings: \${imageResult.visualFindings}');
    print('Recommendation Status: \${imageResult.recommendationStatus}');

    print('\n3. Submitting Questionnaire...');
    final q = Questionnaire(
      duration: 'less_than_one_week',
      itching: 'no',
      painLevel: 1,
      rapidlySpreading: 'no',
      affectedBodyArea: 'face_or_neck',
      fever: 'no',
      highFever: 'no',
      swelling: 'no',
      difficultyBreathing: 'no',
      lipTongueThroatSwelling: 'no',
      bleeding: 'no',
      blistering: 'no',
      openWound: 'no',
      eyeInvolvement: 'no',
      possibleInfection: 'no',
      ageGroup: 'adult',
      recurrent: 'no',
    );
    
    final qResp = await api.saveQuestionnaire(session.id, q);
    print('Safety Urgency: \${qResp.safety.urgency}');
    print('Safety Permission: \${qResp.safety.recommendationPermission}');

    print('\n4. Generating Recommendations...');
    if (qResp.safety.recommendationPermission != 'blocked' && qResp.safety.recommendationPermission != 'escalation_only') {
      final rec = await api.getRecommendation(session.id);
      print('Guidance Level: \${rec.guidanceLevel}');
      print('Action Type: \${rec.draft.recommendedAction.type}');
      print('Explanation: \${rec.draft.explanation}');
    } else {
      print('Recommendations skipped due to safety strictures (\${qResp.safety.recommendationPermission}).');
    }
    
    print('\n[SUCCESS] E2E Verification complete.');
  } catch (e) {
    print('\n[ERROR] E2E Verification failed: \$e');
  } finally {
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }
  }
}
