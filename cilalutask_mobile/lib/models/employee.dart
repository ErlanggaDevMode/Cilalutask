import 'package:flutter/material.dart';

class Assignee {
  final String id;
  final String name;
  final String shortName;
  final String avatar;
  final String division;
  final String role;
  final bool hasTeamBadge;
  final int teamCount;

  const Assignee({
    required this.id,
    required this.name,
    required this.shortName,
    required this.avatar,
    required this.division,
    required this.role,
    this.hasTeamBadge = false,
    this.teamCount = 0,
  });

  Assignee copyWith({
    String? id,
    String? name,
    String? shortName,
    String? avatar,
    String? division,
    String? role,
    bool? hasTeamBadge,
    int? teamCount,
  }) {
    return Assignee(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      avatar: avatar ?? this.avatar,
      division: division ?? this.division,
      role: role ?? this.role,
      hasTeamBadge: hasTeamBadge ?? this.hasTeamBadge,
      teamCount: teamCount ?? this.teamCount,
    );
  }
}

class EmployeePerformance {
  final String id;
  final int rank;
  final String name;
  final String avatar;
  final String division;
  final int completedTasks;
  final int delayedTasks;
  final int score;
  final String statusTag; // 'SANGAT BAIK' | 'OPTIMAL' | 'STABIL' | 'PERLU PENINGKATAN'
  final bool isStar;

  const EmployeePerformance({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.division,
    required this.completedTasks,
    required this.delayedTasks,
    required this.score,
    required this.statusTag,
    this.isStar = false,
  });
}

class DivisionProductivity {
  final String name;
  final int percent;
  final Color color;

  const DivisionProductivity({
    required this.name,
    required this.percent,
    required this.color,
  });
}

class CurrentUser {
  final String name;
  final String role;
  final String email;
  final String avatar;
  final String division;
  final int targetQuarterPercent;
  final int teamEfficiencyPercent;

  const CurrentUser({
    required this.name,
    required this.role,
    required this.email,
    required this.avatar,
    required this.division,
    required this.targetQuarterPercent,
    required this.teamEfficiencyPercent,
  });
}
