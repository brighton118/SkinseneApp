// ignore_for_file: avoid_print
import 'dart:io';
import 'lib/services/api_service.dart';
import 'lib/models/questionnaire.dart';

void main() async {
  print('--- SkinSense Africa API Integration Test ---');
  final dummyImg = File('dummy.jpg');
  if (!dummyImg.existsSync()) {
    dummyImg.writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00]);
  }

  final api = ApiService();

  try {
    print('1. Creating Assessment...');
    final session = await api.createAssessment();
    print('   -> Success! ID: ${session.id}, Status: ${session.status}');

    print('2. Uploading Image...');
    final imgRes = await api.uploadImage(session.id, dummyImg.path);
    print('   -> Success! Condition: ${imgRes.condition}, Confidence: ${imgRes.confidenceLevel}');
    print('   -> Visual Findings: ${imgRes.visualFindings}');

    print('3. Submitting Questionnaire...');
    final q = Questionnaire(
      duration: 'less_than_one_week',
      itching: 'no',
      painLevel: 2,
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
    final qRes = await api.saveQuestionnaire(session.id, q);
    print('   -> Success! Safety Urgency: ${qRes.safety.urgency}, Permission: ${qRes.safety.recommendationPermission}');

    print('4. Generating Recommendations...');
    if (qRes.safety.recommendationPermission != 'blocked') {
      final recRes = await api.getRecommendation(session.id);
      print('   -> Success! Guidance: ${recRes.guidanceLevel}');
      print('   -> Draft Explanation: ${recRes.draft.explanation}');
    } else {
      print('   -> Skipped. Permission is blocked.');
    }

    print('\n### ALL BACKEND WORKFLOWS COMPLETED SUCCESSFULLY ###');

  } catch (e) {
    print('\n### ERROR DURING WORKFLOW ###');
    print(e.toString());
  }
}
