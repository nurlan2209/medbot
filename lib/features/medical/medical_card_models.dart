class MedicalCard {
  final PersonalInfo personalInfo;
  final List<String> chronicConditions;
  final List<Allergy> allergies;
  final List<Medication> currentMedications;
  final List<MedicalDocument> documents;

  const MedicalCard({
    required this.personalInfo,
    required this.chronicConditions,
    required this.allergies,
    required this.currentMedications,
    required this.documents,
  });

  factory MedicalCard.empty() => const MedicalCard(
        personalInfo: PersonalInfo.empty(),
        chronicConditions: [],
        allergies: [],
        currentMedications: [],
        documents: [],
      );

  factory MedicalCard.fromJson(Map<String, dynamic> json) {
    final pi = (json['personalInfo'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    return MedicalCard(
      personalInfo: PersonalInfo.fromJson(pi),
      chronicConditions: ((json['chronicConditions'] as List?) ?? const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      allergies: ((json['allergies'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => Allergy.fromJson(e.cast<String, dynamic>()))
          .toList(),
      currentMedications: ((json['currentMedications'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => Medication.fromJson(e.cast<String, dynamic>()))
          .toList(),
      documents: ((json['documents'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => MedicalDocument.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'chronicConditions': chronicConditions,
      'allergies': allergies.map((a) => a.toJson()).toList(),
      'currentMedications': currentMedications.map((m) => m.toJson()).toList(),
      'documents': documents.map((d) => d.toJson()).toList(),
    };
  }

  MedicalCard copyWith({
    PersonalInfo? personalInfo,
    List<String>? chronicConditions,
    List<Allergy>? allergies,
    List<Medication>? currentMedications,
    List<MedicalDocument>? documents,
  }) {
    return MedicalCard(
      personalInfo: personalInfo ?? this.personalInfo,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      documents: documents ?? this.documents,
    );
  }
}

class PersonalInfo {
  final String name;
  final String dateOfBirth;
  final String bloodType;
  final String height;
  final String weight;

  const PersonalInfo({
    required this.name,
    required this.dateOfBirth,
    required this.bloodType,
    required this.height,
    required this.weight,
  });

  const PersonalInfo.empty()
      : name = '',
        dateOfBirth = '',
        bloodType = '',
        height = '',
        weight = '';

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: (json['name'] ?? '').toString(),
      dateOfBirth: (json['dateOfBirth'] ?? '').toString(),
      bloodType: (json['bloodType'] ?? '').toString(),
      height: (json['height'] ?? '').toString(),
      weight: (json['weight'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'dateOfBirth': dateOfBirth,
        'bloodType': bloodType,
        'height': height,
        'weight': weight,
      };
}

class Allergy {
  final String name;
  final String severity;
  const Allergy({required this.name, required this.severity});

  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      name: (json['name'] ?? '').toString(),
      severity: (json['severity'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'severity': severity};
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  const Medication({required this.name, required this.dosage, required this.frequency});

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: (json['name'] ?? '').toString(),
      dosage: (json['dosage'] ?? '').toString(),
      frequency: (json['frequency'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'dosage': dosage, 'frequency': frequency};
}

class MedicalDocument {
  final String name;
  final String date;
  const MedicalDocument({required this.name, required this.date});

  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      name: (json['name'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'date': date};
}

