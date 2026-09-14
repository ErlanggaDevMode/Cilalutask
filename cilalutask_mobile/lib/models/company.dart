enum JoinRequestStatus {
  pending,
  approved,
  rejected,
}

class Company {
  final String id;
  final String name;
  final String code; // Unique Company Code (e.g. CILALU-88, CORP-4821)
  final String adminName;
  final String adminEmail;
  final String adminPassword;
  final DateTime createdAt;
  final String industry;

  const Company({
    required this.id,
    required this.name,
    required this.code,
    required this.adminName,
    required this.adminEmail,
    required this.adminPassword,
    required this.createdAt,
    this.industry = 'Teknologi & Operasional',
  });

  Company copyWith({
    String? id,
    String? name,
    String? code,
    String? adminName,
    String? adminEmail,
    String? adminPassword,
    DateTime? createdAt,
    String? industry,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      adminName: adminName ?? this.adminName,
      adminEmail: adminEmail ?? this.adminEmail,
      adminPassword: adminPassword ?? this.adminPassword,
      createdAt: createdAt ?? this.createdAt,
      industry: industry ?? this.industry,
    );
  }
}

class JoinRequest {
  final String id;
  final String companyCode;
  final String companyName;
  final String userName;
  final String userEmail;
  final String userPassword;
  final String division;
  final String role;
  final String avatar;
  final JoinRequestStatus status;
  final DateTime requestedAt;

  const JoinRequest({
    required this.id,
    required this.companyCode,
    required this.companyName,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.division,
    required this.role,
    required this.avatar,
    this.status = JoinRequestStatus.pending,
    required this.requestedAt,
  });

  JoinRequest copyWith({
    String? id,
    String? companyCode,
    String? companyName,
    String? userName,
    String? userEmail,
    String? userPassword,
    String? division,
    String? role,
    String? avatar,
    JoinRequestStatus? status,
    DateTime? requestedAt,
  }) {
    return JoinRequest(
      id: id ?? this.id,
      companyCode: companyCode ?? this.companyCode,
      companyName: companyName ?? this.companyName,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPassword: userPassword ?? this.userPassword,
      division: division ?? this.division,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }
}
