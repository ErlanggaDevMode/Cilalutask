import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task.dart';
import '../models/sop.dart';
import '../models/activity.dart';
import '../models/employee.dart';
import '../models/notification_item.dart';
import '../models/user_role.dart';
import '../models/chat_model.dart';
import '../models/company.dart';
import '../data/mock_data.dart';

class AppStateController extends ChangeNotifier {
  // Authentication & Role
  bool _isAuthenticated = false; // Starts at Login screen; allows instant demo login as Admin or Karyawan
  UserRole _currentUserRole = UserRole.admin;
  Assignee? _currentEmployee; // null if Admin

  // Multi-Company System
  List<Company> _companies = [
    Company(
      id: 'comp-1',
      name: 'PT Cilalu Sentosa',
      code: 'CILALU-88',
      adminName: 'Sarah Pratama',
      adminEmail: 'sarah.pratama@cilulataks.id',
      adminPassword: 'password123',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      industry: 'Teknologi & Operasional Cloud',
    ),
  ];
  late Company _currentCompany;
  List<JoinRequest> _joinRequests = [];
  bool _isBlankMode = false;
  String? _customUserAvatar;

  int _currentTabIndex = 0;
  String _teamSubTab = 'tim'; // 'tim' | 'notif'
  NotificationItem? _activeInAppNotification;
  Timer? _inAppBannerTimer;

  AppStateController() {
    _currentCompany = _companies.first;
  }

  List<Task> _tasks = List.from(kInitialTasks);
  List<SOPDocument> _sops = List.from(kInitialSops);
  List<ActivityItem> _activities = List.from(kInitialActivities);
  List<NotificationItem> _notifications = List.from(kNotificationsData);
  final CurrentUser _currentUser = kCurrentUser;
  List<Assignee> _employees = List.from(kEmployees);

  // Chat Channels & Messages
  List<ChatChannel> _channels = [
    const ChatChannel(
      id: 'ch-umum',
      name: '#umum',
      description: 'Saluran pengumuman dan diskusi seluruh divisi',
      lastMessage: 'Halo tim, mohon cek dashboard tugas & SOP hari ini ya.',
      lastMessageTime: '10:15',
      unreadCount: 2,
    ),
    const ChatChannel(
      id: 'ch-ops',
      name: '#operasional-gudang',
      description: 'Koordinasi stok opname dan logistik cikarang',
      lastMessage: 'Pemeriksaan modul TV rack A1-A12 telah selesai.',
      lastMessageTime: '09:45',
      unreadCount: 0,
    ),
    const ChatChannel(
      id: 'ch-it',
      name: '#it-tech-core',
      description: 'DevOps, database Aurora, dan keamanan cloud server',
      lastMessage: 'Replication slot AWS DMS aktif tanpa kendala.',
      lastMessageTime: '09:30',
      unreadCount: 1,
    ),
    const ChatChannel(
      id: 'ch-marketing',
      name: '#pemasaran-kreatif',
      description: 'Kampanye promo mid-year sale dan konten media sosial',
      lastMessage: 'Visual master banner 3 format telah rampung.',
      lastMessageTime: 'Kemarin',
      unreadCount: 0,
    ),
    const ChatChannel(
      id: 'ch-finance',
      name: '#finance-akuntansi',
      description: 'Rekonsiliasi pajak bulanan dan pengajuan klaim staf',
      lastMessage: 'File CSV SPT masa siap di-upload ke portal DJP.',
      lastMessageTime: 'Kemarin',
      unreadCount: 0,
    ),
  ];

  List<ChatMessage> _messages = [
    ChatMessage(
      id: 'msg-1',
      channelId: 'ch-umum',
      senderId: 'admin-1',
      senderName: 'Sarah Pratama',
      senderAvatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Admin / Manager',
      content: 'Selamat pagi seluruh tim Cilalutask! Mohon cek dashboard tugas masing-masing dan verifikasi kepatuhan SOP K3 terbaru.',
      time: '08:30',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ChatMessage(
      id: 'msg-2',
      channelId: 'ch-umum',
      senderId: 'emp-1',
      senderName: 'Kevin Maulana',
      senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Lead Cloud Engineer',
      content: 'Pagi Bu Sarah! Migrasi database transaksi ke Aurora sedang berjalan lancar, tahap simulasi auto-failover.',
      time: '08:45',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    ),
    ChatMessage(
      id: 'msg-3',
      channelId: 'ch-umum',
      senderId: 'emp-3',
      senderName: 'Budi Santoso',
      senderAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Supervisor Gudang',
      content: 'Pemeriksaan stok fisik Cikarang sudah 88%, berita acara akan segera kami unggah sebelum pukul 17:00.',
      time: '09:10',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
    ),
    ChatMessage(
      id: 'msg-4',
      channelId: 'ch-umum',
      senderId: 'emp-2',
      senderName: 'Nadia Salsabila',
      senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Senior Content Strategist',
      content: 'Materi kampanye Mid-Year Sale siap tayang di kanal official reels dan newsletter blast.',
      time: '09:25',
      timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
  ];

  // Auth Getters
  bool get isAuthenticated => _isAuthenticated;
  UserRole get currentRole => _currentUserRole;
  bool get isAdmin => _currentUserRole == UserRole.admin;
  bool get isUser => _currentUserRole == UserRole.user;
  Assignee? get currentEmployee => _currentEmployee;

  String get currentUserName =>
      _currentUserRole == UserRole.admin
          ? (_currentCompany.adminName.isNotEmpty ? _currentCompany.adminName : _currentUser.name)
          : (_currentEmployee?.name ?? 'Karyawan');

  String get currentUserRoleTitle =>
      _currentUserRole == UserRole.admin ? _currentUser.role : (_currentEmployee?.role ?? 'Karyawan');

  String get currentUserAvatar =>
      _customUserAvatar ??
      (_currentUserRole == UserRole.admin
          ? ''
          : (_currentEmployee?.avatar ?? ''));

  void updateUserAvatar(String newAvatar) {
    _customUserAvatar = newAvatar;
    notifyListeners();
  }

  String get currentUserDivision =>
      _currentUserRole == UserRole.admin ? _currentUser.division : (_currentEmployee?.division ?? 'Operasional');

  String get currentUserEmail =>
      _currentUserRole == UserRole.admin
          ? (_currentCompany.adminEmail.isNotEmpty ? _currentCompany.adminEmail : _currentUser.email)
          : '${_currentEmployee?.shortName.toLowerCase().replaceAll(' ', '').replaceAll('.', '') ?? 'user'}@${_currentCompany.code.toLowerCase()}.id';

  // Company & Multi-tenant Getters
  Company get currentCompany => _currentCompany;
  List<Company> get companies => List.unmodifiable(_companies);
  List<JoinRequest> get joinRequests => List.unmodifiable(_joinRequests);
  List<JoinRequest> get pendingJoinRequests =>
      _joinRequests.where((r) => r.status == JoinRequestStatus.pending && r.companyCode.toUpperCase() == _currentCompany.code.toUpperCase()).toList();
  int get pendingJoinRequestsCount => pendingJoinRequests.length;
  bool get isBlankMode => _isBlankMode;

  void switchCompany(Company comp) {
    _currentCompany = comp;
    notifyListeners();
  }

  // Navigation & Data Getters
  int get currentTabIndex => _currentTabIndex;
  List<Task> get tasks => List.unmodifiable(_tasks);
  List<SOPDocument> get sops => List.unmodifiable(_sops);
  List<ActivityItem> get activities => List.unmodifiable(_activities);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  CurrentUser get currentUser => _currentUser;
  List<Assignee> get employees => List.unmodifiable(_employees);

  int get activeReviewCount => _tasks.where((t) => t.needsReview).length;
  int get unreadNotificationsCount => _notifications.where((n) => n.unread).length;
  NotificationItem? get activeInAppNotification => _activeInAppNotification;
  String get teamSubTab => _teamSubTab;

  void setTeamSubTab(String subTab) {
    if (_teamSubTab != subTab) {
      _teamSubTab = subTab;
      notifyListeners();
    }
  }

  void openNotificationsTab() {
    _teamSubTab = 'notif';
    setTab(5);
  }

  void pushNotification(NotificationItem item, {bool showBanner = true}) {
    _notifications = [item, ..._notifications];

    if (showBanner) {
      _inAppBannerTimer?.cancel();
      _activeInAppNotification = item;
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}

      _inAppBannerTimer = Timer(const Duration(seconds: 4), () {
        dismissActiveNotification();
      });
    }

    notifyListeners();
  }

  void dismissActiveNotification() {
    _inAppBannerTimer?.cancel();
    _inAppBannerTimer = null;
    if (_activeInAppNotification != null) {
      _activeInAppNotification = null;
      notifyListeners();
    }
  }

  // Chat Getters
  List<ChatChannel> get channels => List.unmodifiable(_channels);
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  List<ChatMessage> getMessagesForChannel(String channelId) {
    return _messages.where((m) => m.channelId == channelId).toList();
  }

  List<ChatMessage> getDirectMessagesWith(String otherUserId) {
    final myId = _currentUserRole == UserRole.admin ? 'admin-1' : (_currentEmployee?.id ?? 'emp-1');
    return _messages.where((m) {
      return (m.senderId == myId && m.receiverId == otherUserId) ||
          (m.senderId == otherUserId && m.receiverId == myId);
    }).toList();
  }

  // Company & Multi-tenant Registration Methods
  void registerCompany({
    required String name,
    required String code,
    required String adminName,
    required String adminEmail,
    required String adminPassword,
    String industry = 'Operasional & Bisnis',
  }) {
    final cleanCode = code.trim().toUpperCase();
    final newComp = Company(
      id: 'comp-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      code: cleanCode,
      adminName: adminName.trim(),
      adminEmail: adminEmail.trim(),
      adminPassword: adminPassword,
      createdAt: DateTime.now(),
      industry: industry,
    );

    _companies = [newComp, ..._companies];
    _currentCompany = newComp;
    _isBlankMode = true;

    // Start with completely blank state for the new company
    _tasks = [];
    _sops = [];
    _activities = [];
    _notifications = [];
    _employees = [];
    _channels = [
      ChatChannel(
        id: 'ch-umum',
        name: '#umum',
        description: 'Saluran pengumuman dan diskusi ${newComp.name}',
        lastMessage: 'Selamat datang di ${newComp.name}! Bagikan Kode ID $cleanCode untuk mengundang tim.',
        lastMessageTime: 'Baru saja',
        unreadCount: 0,
      ),
    ];

    _currentUserRole = UserRole.admin;
    _currentEmployee = null;
    _isAuthenticated = true;
    _currentTabIndex = 0;

    pushNotification(
      NotificationItem(
        id: 'notif-welcome-${DateTime.now().millisecondsSinceEpoch}',
        title: '🏢 Perusahaan ${newComp.name} Berhasil Dibuat!',
        description: 'ID Perusahaan Anda: $cleanCode. Bagikan ke karyawan agar mereka dapat bergabung.',
        time: 'Baru saja',
        type: 'system',
        targetTab: 5,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );

    notifyListeners();
  }

  JoinRequest submitJoinRequest({
    required String companyCode,
    required String name,
    required String email,
    required String password,
    required String division,
    required String role,
  }) {
    final cleanCode = companyCode.trim().toUpperCase();
    final targetComp = _companies.firstWhere(
      (c) => c.code.toUpperCase() == cleanCode,
      orElse: () => Company(
        id: 'comp-ext',
        name: 'Perusahaan $cleanCode',
        code: cleanCode,
        adminName: 'Admin Perusahaan',
        adminEmail: 'admin@${cleanCode.toLowerCase()}.id',
        adminPassword: 'password123',
        createdAt: DateTime.now(),
      ),
    );

    final req = JoinRequest(
      id: 'req-${DateTime.now().millisecondsSinceEpoch}',
      companyCode: cleanCode,
      companyName: targetComp.name,
      userName: name.trim(),
      userEmail: email.trim(),
      userPassword: password,
      division: division.trim(),
      role: role.trim(),
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=256',
      status: JoinRequestStatus.pending,
      requestedAt: DateTime.now(),
    );

    _joinRequests = [req, ..._joinRequests];

    pushNotification(
      NotificationItem(
        id: 'notif-join-${DateTime.now().millisecondsSinceEpoch}',
        title: '👥 Permintaan Bergabung Baru!',
        description: '${req.userName} memohon bergabung ke divisi ${req.division} ($cleanCode).',
        time: 'Baru saja',
        type: 'system',
        targetTab: 5,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );

    notifyListeners();
    return req;
  }

  void acceptJoinRequest(String requestId) {
    JoinRequest? acceptedReq;
    _joinRequests = _joinRequests.map((r) {
      if (r.id == requestId) {
        acceptedReq = r.copyWith(status: JoinRequestStatus.approved);
        return acceptedReq!;
      }
      return r;
    }).toList();

    if (acceptedReq != null) {
      final req = acceptedReq!;
      final newEmp = Assignee(
        id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
        name: req.userName,
        shortName: req.userName.split(' ').first,
        avatar: req.avatar,
        division: req.division,
        role: req.role,
        hasTeamBadge: true,
        teamCount: 1,
      );

      _employees = [..._employees, newEmp];

      pushNotification(
        NotificationItem(
          id: 'notif-accepted-${DateTime.now().millisecondsSinceEpoch}',
          title: '✅ ${req.userName} Diterima Bergabung!',
          description: 'Karyawan resmi masuk tim divisi ${req.division} (${_currentCompany.name}).',
          time: 'Baru saja',
          type: 'system',
          targetTab: 5,
          timestamp: DateTime.now(),
        ),
        showBanner: true,
      );
    }

    notifyListeners();
  }

  void rejectJoinRequest(String requestId) {
    _joinRequests = _joinRequests.map((r) {
      if (r.id == requestId) {
        return r.copyWith(status: JoinRequestStatus.rejected);
      }
      return r;
    }).toList();
    notifyListeners();
  }

  void resetToBlankState() {
    _isBlankMode = true;
    _tasks = [];
    _sops = [];
    _activities = [];
    _notifications = [];
    _employees = [];
    notifyListeners();
  }

  void loadSampleDemoData() {
    _isBlankMode = false;
    _tasks = List.from(kInitialTasks);
    _sops = List.from(kInitialSops);
    _activities = List.from(kInitialActivities);
    _notifications = List.from(kNotificationsData);
    _employees = List.from(kEmployees);
    notifyListeners();
  }

  void createChannel({required String name, required String description}) {
    final cleanName = name.startsWith('#') ? name : '#$name';
    final newCh = ChatChannel(
      id: 'ch-${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      description: description,
      lastMessage: 'Saluran baru dibuat oleh $currentUserName',
      lastMessageTime: 'Baru saja',
      unreadCount: 0,
    );
    _channels = [..._channels, newCh];
    notifyListeners();
  }

  // Auth Methods
  void loginAsAdmin({Company? company}) {
    if (company != null) {
      _currentCompany = company;
    }
    _currentUserRole = UserRole.admin;
    _currentEmployee = null;
    _isAuthenticated = true;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void loginAsEmployee(Assignee employee, {Company? company}) {
    if (company != null) {
      _currentCompany = company;
    }
    _currentUserRole = UserRole.user;
    _currentEmployee = employee;
    _isAuthenticated = true;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void setTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // Task Methods
  void createTask(Task newTask) {
    // Only Admin can create tasks
    if (!isAdmin) return;

    _tasks = [newTask, ..._tasks];

    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'menerbitkan tugas baru',
      targetObject: newTask.title,
      timeAgo: 'Baru saja',
      department: newTask.division,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    final assigneeName = newTask.assignee.name;
    pushNotification(
      NotificationItem(
        id: 'notif-task-${DateTime.now().millisecondsSinceEpoch}',
        title: '📋 Tugas Baru Diterbitkan',
        description: 'Tugas "${newTask.title}" telah ditugaskan untuk $assigneeName.',
        time: 'Baru saja',
        type: 'task',
        targetTab: 1,
        targetId: newTask.id,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );
  }

  void saveProgress(String taskId, List<Subtask> updatedSubtasks, int progressPercent) {
    // Only User (Karyawan) can update task progress
    _tasks = _tasks.map((t) {
      if (t.id == taskId) {
        final isDone = progressPercent == 100;
        return t.copyWith(
          subtasks: updatedSubtasks,
          progressPercent: progressPercent,
          status: isDone ? TaskStatus.completed : TaskStatus.inProgress,
          needsReview: isDone ? true : t.needsReview,
        );
      }
      return t;
    }).toList();

    final target = _tasks.firstWhere((t) => t.id == taskId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'memperbarui progres tugas',
      targetObject: target.title,
      actionSuffix: 'ke $progressPercent%.',
      timeAgo: 'Baru saja',
      department: target.division,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    pushNotification(
      NotificationItem(
        id: 'notif-prog-${DateTime.now().millisecondsSinceEpoch}',
        title: '📈 Progres Tugas Diperbarui ($progressPercent%)',
        description: '$currentUserName memperbarui "${target.title}" ke $progressPercent%.',
        time: 'Baru saja',
        type: 'task',
        targetTab: 1,
        targetId: target.id,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );
  }

  void approveTask(String taskId) {
    // Only Admin can review and approve tasks
    if (!isAdmin) return;

    _tasks = _tasks.map((t) {
      if (t.id == taskId) {
        return t.copyWith(
          status: TaskStatus.completed,
          progressPercent: 100,
          subtasks: t.subtasks.map((st) => st.copyWith(completed: true)).toList(),
          needsReview: false,
        );
      }
      return t;
    }).toList();

    final target = _tasks.firstWhere((t) => t.id == taskId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'menyetujui & menyelesaikan tugas',
      targetObject: target.title,
      timeAgo: 'Baru saja',
      department: target.division,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    pushNotification(
      NotificationItem(
        id: 'notif-appr-${DateTime.now().millisecondsSinceEpoch}',
        title: '✅ Tugas Telah Disetujui & Selesai',
        description: 'Sarah Pratama telah menyetujui tugas "${target.title}".',
        time: 'Baru saja',
        type: 'review',
        targetTab: 1,
        targetId: target.id,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );
  }

  // SOP Methods
  void addSop(SOPDocument newSop) {
    if (!isAdmin) return;

    _sops = [newSop, ..._sops];

    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'menerbitkan SOP baru',
      targetObject: newSop.title,
      timeAgo: 'Baru saja',
      department: newSop.category,
      type: 'sop',
    );
    _activities = [newActivity, ..._activities];

    pushNotification(
      NotificationItem(
        id: 'notif-sop-${DateTime.now().millisecondsSinceEpoch}',
        title: '📑 SOP Baru Diterbitkan',
        description: 'Dokumen "${newSop.title}" (${newSop.category}) siap dipelajari.',
        time: 'Baru saja',
        type: 'sop',
        targetTab: 2,
        targetId: newSop.id,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );
  }

  void confirmReadSop(String sopId) {
    _sops = _sops.map((s) {
      if (s.id == sopId) {
        final currentPct = s.readProgressPercent ?? 94;
        final nextPct = (currentPct + 6).clamp(0, 100);
        return s.copyWith(
          isReadByMe: true,
          readProgressPercent: nextPct,
          isUrgentMandatory: false,
        );
      }
      return s;
    }).toList();

    final targetSop = _sops.firstWhere((s) => s.id == sopId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'memverifikasi kepatuhan SOP',
      targetObject: targetSop.title,
      timeAgo: 'Baru saja',
      department: targetSop.category,
      type: 'sop',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void toggleBookmarkSop(String sopId) {
    _sops = _sops.map((s) {
      if (s.id == sopId) {
        return s.copyWith(isBookmarked: !s.isBookmarked);
      }
      return s;
    }).toList();

    notifyListeners();
  }

  // Broadcast & Notifications
  void sendBroadcast(String message, String targetDivision) {
    if (!isAdmin) return;

    final preview = message.length > 35 ? '${message.substring(0, 35)}...' : message;
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'mengirim broadcast ($targetDivision):',
      targetObject: '"$preview"',
      timeAgo: 'Baru saja',
      department: targetDivision,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    pushNotification(
      NotificationItem(
        id: 'notif-bc-${DateTime.now().millisecondsSinceEpoch}',
        title: '📢 Siaran Pengumuman ($targetDivision)',
        description: message,
        time: 'Baru saja',
        type: 'system',
        targetTab: 5,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(unread: false)).toList();
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    _notifications = _notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(unread: false);
      }
      return n;
    }).toList();
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications = [];
    notifyListeners();
  }

  int _simIndex = 0;
  void simulateIncomingRealtimeEvent() {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final events = [
      NotificationItem(
        id: 'sim-${now.millisecondsSinceEpoch}-1',
        title: '💬 Pesan Masuk (#it-tech-core)',
        description: 'Kevin M: Database transaksi Aurora berhasil sinkron tanpa downtime.',
        time: 'Baru saja ($timeStr)',
        type: 'chat',
        senderName: 'Kevin Maulana',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=256',
        targetTab: 4,
        targetId: 'ch-it',
        timestamp: now,
      ),
      NotificationItem(
        id: 'sim-${now.millisecondsSinceEpoch}-2',
        title: '📋 Update Subtask Operasional',
        description: 'Budi Santoso telah menyelesaikan checklist Pallet B4 di Cikarang.',
        time: 'Baru saja ($timeStr)',
        type: 'task',
        senderName: 'Budi Santoso',
        senderAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=256',
        targetTab: 1,
        timestamp: now,
      ),
      NotificationItem(
        id: 'sim-${now.millisecondsSinceEpoch}-3',
        title: '🚨 Peringatan Batas Waktu',
        description: 'Tugas Audit Stok Gudang Cikarang tersisa 2 jam sebelum batas akhir.',
        time: 'Baru saja ($timeStr)',
        type: 'deadline',
        targetTab: 1,
        timestamp: now,
      ),
      NotificationItem(
        id: 'sim-${now.millisecondsSinceEpoch}-4',
        title: '👑 Permintaan Review Aset',
        description: 'Nadia Salsabila mengajukan review materi visual Mid-Year Sale.',
        time: 'Baru saja ($timeStr)',
        type: 'review',
        senderName: 'Nadia Salsabila',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=256',
        targetTab: 1,
        timestamp: now,
      ),
      NotificationItem(
        id: 'sim-${now.millisecondsSinceEpoch}-5',
        title: '📑 SOP Wajib: Prosedur APD',
        description: 'Pembaruan keselamatan alat berat baru memerlukan verifikasi staf.',
        time: 'Baru saja ($timeStr)',
        type: 'sop',
        targetTab: 2,
        timestamp: now,
      ),
    ];

    final event = events[_simIndex % events.length];
    _simIndex++;
    pushNotification(event, showBanner: true);
  }

  // Chat Methods
  void sendChatMessage({
    required String content,
    String? channelId,
    String? receiverId,
  }) {
    if (content.trim().isEmpty) return;

    final now = DateTime.now();
    final timeFormatted = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final myId = _currentUserRole == UserRole.admin ? 'admin-1' : (_currentEmployee?.id ?? 'emp-1');

    final newMsg = ChatMessage(
      id: 'msg-${now.millisecondsSinceEpoch}',
      channelId: channelId,
      receiverId: receiverId,
      senderId: myId,
      senderName: currentUserName,
      senderAvatar: currentUserAvatar,
      senderRole: currentUserRoleTitle,
      content: content.trim(),
      time: timeFormatted,
      timestamp: now,
    );

    _messages = [..._messages, newMsg];

    // Update last message in channel if applicable
    if (channelId != null) {
      _channels = _channels.map((ch) {
        if (ch.id == channelId) {
          return ch.copyWith(
            lastMessage: content.trim(),
            lastMessageTime: timeFormatted,
          );
        }
        return ch;
      }).toList();
    }

    final channelName = channelId != null
        ? (_channels.firstWhere((c) => c.id == channelId, orElse: () => _channels.first).name)
        : 'Pesan Langsung';
    pushNotification(
      NotificationItem(
        id: 'notif-chat-${DateTime.now().millisecondsSinceEpoch}',
        title: '💬 $currentUserName di $channelName',
        description: content.trim(),
        time: 'Baru saja',
        type: 'chat',
        senderName: currentUserName,
        senderAvatar: currentUserAvatar,
        targetTab: 4,
        targetId: channelId ?? receiverId,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );
  }

  @override
  void dispose() {
    _inAppBannerTimer?.cancel();
    super.dispose();
  }
}
