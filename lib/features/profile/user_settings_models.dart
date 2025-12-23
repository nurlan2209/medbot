class UserSettings {
  final bool useMedicalDataInAI;
  final bool storeChatHistory;
  final bool shareAnalytics;

  const UserSettings({
    required this.useMedicalDataInAI,
    required this.storeChatHistory,
    required this.shareAnalytics,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      useMedicalDataInAI: json['useMedicalDataInAI'] == true,
      storeChatHistory: json['storeChatHistory'] != false,
      shareAnalytics: json['shareAnalytics'] == true,
    );
  }

  Map<String, dynamic> toPatchJson() {
    return {
      'useMedicalDataInAI': useMedicalDataInAI,
      'storeChatHistory': storeChatHistory,
      'shareAnalytics': shareAnalytics,
    };
  }

  UserSettings copyWith({
    bool? useMedicalDataInAI,
    bool? storeChatHistory,
    bool? shareAnalytics,
  }) {
    return UserSettings(
      useMedicalDataInAI: useMedicalDataInAI ?? this.useMedicalDataInAI,
      storeChatHistory: storeChatHistory ?? this.storeChatHistory,
      shareAnalytics: shareAnalytics ?? this.shareAnalytics,
    );
  }
}

