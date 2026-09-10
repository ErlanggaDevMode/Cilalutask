class ContentSection {
  final String heading;
  final List<String> items;

  const ContentSection({
    required this.heading,
    required this.items,
  });
}

class SOPDocument {
  final String id;
  final String code;
  final String title;
  final String category;
  final String version;
  final bool isUrgentMandatory;
  final bool isNewUpdate;
  final bool isBookmarked;
  final String? deadlineWarning;
  final String? complianceTag;
  final String? complianceRatioText;
  final int? readProgressPercent;
  final String? readTeamCount;
  final String lastUpdatedText;
  final String? fileInfo;
  final String? checkPoints;
  final String? duration;
  final String? description;
  final List<ContentSection> contentSections;
  final bool isReadByMe;

  const SOPDocument({
    required this.id,
    required this.code,
    required this.title,
    required this.category,
    required this.version,
    this.isUrgentMandatory = false,
    this.isNewUpdate = false,
    this.isBookmarked = false,
    this.deadlineWarning,
    this.complianceTag,
    this.complianceRatioText,
    this.readProgressPercent,
    this.readTeamCount,
    required this.lastUpdatedText,
    this.fileInfo,
    this.checkPoints,
    this.duration,
    this.description,
    this.contentSections = const [],
    this.isReadByMe = false,
  });

  SOPDocument copyWith({
    String? id,
    String? code,
    String? title,
    String? category,
    String? version,
    bool? isUrgentMandatory,
    bool? isNewUpdate,
    bool? isBookmarked,
    String? deadlineWarning,
    String? complianceTag,
    String? complianceRatioText,
    int? readProgressPercent,
    String? readTeamCount,
    String? lastUpdatedText,
    String? fileInfo,
    String? checkPoints,
    String? duration,
    String? description,
    List<ContentSection>? contentSections,
    bool? isReadByMe,
  }) {
    return SOPDocument(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      category: category ?? this.category,
      version: version ?? this.version,
      isUrgentMandatory: isUrgentMandatory ?? this.isUrgentMandatory,
      isNewUpdate: isNewUpdate ?? this.isNewUpdate,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      deadlineWarning: deadlineWarning ?? this.deadlineWarning,
      complianceTag: complianceTag ?? this.complianceTag,
      complianceRatioText: complianceRatioText ?? this.complianceRatioText,
      readProgressPercent: readProgressPercent ?? this.readProgressPercent,
      readTeamCount: readTeamCount ?? this.readTeamCount,
      lastUpdatedText: lastUpdatedText ?? this.lastUpdatedText,
      fileInfo: fileInfo ?? this.fileInfo,
      checkPoints: checkPoints ?? this.checkPoints,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      contentSections: contentSections ?? this.contentSections,
      isReadByMe: isReadByMe ?? this.isReadByMe,
    );
  }
}
