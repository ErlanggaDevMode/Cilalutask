export type TabType = 'beranda' | 'tugas' | 'sop' | 'laporan' | 'tim';

export type DivisionType = 'Semua' | 'Operasional' | 'IT & Tech' | 'Pemasaran' | 'Finance & Akuntansi';

export type PriorityType = 'Prioritas Tinggi' | 'Prioritas Sedang' | 'Prioritas Rendah';

export type TaskStatus = 'Belum Dimulai' | 'Dalam Proses' | 'Selesai';

export interface Subtask {
  id: string;
  title: string;
  completed: boolean;
}

export interface Assignee {
  id: string;
  name: string;
  shortName: string;
  avatar: string;
  division: string;
  role: string;
  hasTeamBadge?: boolean;
  teamCount?: number;
}

export interface Task {
  id: string;
  title: string;
  description: string;
  division: string;
  priority: PriorityType;
  status: TaskStatus;
  deadlineLabel: string;
  isUrgentDeadline?: boolean;
  isToday?: boolean;
  subtasks: Subtask[];
  assignee: Assignee;
  progressPercent: number;
  updatedAt?: string;
  needsReview?: boolean;
}

export interface SOPDocument {
  id: string;
  code: string;
  title: string;
  category: string;
  version: string;
  isUrgentMandatory?: boolean;
  isNewUpdate?: boolean;
  isBookmarked?: boolean;
  deadlineWarning?: string;
  complianceTag?: string;
  complianceRatioText?: string;
  readProgressPercent?: number;
  readTeamCount?: string;
  lastUpdatedText: string;
  fileInfo?: string;
  checkPoints?: string;
  duration?: string;
  description?: string;
  contentSections?: {
    heading: string;
    items: string[];
  }[];
  isReadByMe?: boolean;
}

export interface EmployeePerformance {
  id: string;
  rank: number;
  name: string;
  avatar: string;
  division: string;
  completedTasks: number;
  delayedTasks: number;
  score: number;
  statusTag: 'SANGAT BAIK' | 'OPTIMAL' | 'STABIL' | 'PERLU PENINGKATAN';
  isStar?: boolean;
}

export interface ActivityItem {
  id: string;
  userName: string;
  userAvatar: string;
  actionPrefix: string;
  targetObject: string;
  actionSuffix?: string;
  timeAgo: string;
  department: string;
  type: 'sop' | 'task';
}
