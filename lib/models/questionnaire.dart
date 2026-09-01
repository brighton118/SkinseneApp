class Questionnaire {
  final String duration;
  final String itching;
  final int? painLevel;
  final String rapidlySpreading;
  final String affectedBodyArea;
  final String fever;
  final String highFever;
  final String swelling;
  final String difficultyBreathing;
  final String lipTongueThroatSwelling;
  final String bleeding;
  final String blistering;
  final String openWound;
  final String eyeInvolvement;
  final String possibleInfection;
  final String ageGroup;
  final String recurrent;
  
  final List<String>? previousTreatment;
  final List<String>? knownAllergies;
  final List<String>? currentProducts;

  Questionnaire({
    required this.duration,
    required this.itching,
    this.painLevel,
    required this.rapidlySpreading,
    required this.affectedBodyArea,
    required this.fever,
    required this.highFever,
    required this.swelling,
    required this.difficultyBreathing,
    required this.lipTongueThroatSwelling,
    required this.bleeding,
    required this.blistering,
    required this.openWound,
    required this.eyeInvolvement,
    required this.possibleInfection,
    required this.ageGroup,
    required this.recurrent,
    this.previousTreatment,
    this.knownAllergies,
    this.currentProducts,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'itching': itching,
      if (painLevel != null) 'pain_level': painLevel,
      'rapidly_spreading': rapidlySpreading,
      'affected_body_area': affectedBodyArea,
      'fever': fever,
      'high_fever': highFever,
      'swelling': swelling,
      'difficulty_breathing': difficultyBreathing,
      'lip_tongue_throat_swelling': lipTongueThroatSwelling,
      'bleeding': bleeding,
      'blistering': blistering,
      'open_wound': openWound,
      'eye_involvement': eyeInvolvement,
      'possible_infection': possibleInfection,
      'age_group': ageGroup,
      'recurrent': recurrent,
      if (previousTreatment != null) 'previous_treatment': previousTreatment,
      if (knownAllergies != null) 'known_allergies': knownAllergies,
      if (currentProducts != null) 'current_products': currentProducts,
    };
  }
}
