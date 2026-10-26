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
import '../services/auth_service.dart';
import '../repositories/cilalu_repository.dart';
import '../repositories/data_exception.dart';

class AppStateController extends ChangeNotifier {
  final CilaluRepository _repository;
  final AuthService _authService;

  bool _isStorageLoaded = false;
  bool get isStorageLoaded => _isStorageLoaded;
  bool get isCloudConnected => _repository.isCloudAvailable;
  SyncStatus get syncStatus => _repository.syncStatus;
  String? get lastSyncError => _repository.lastError;

  bool _isLoadingCompanyData = false;
  bool get isLoadingCompanyData => _isLoadingCompanyData;

  AuthService get authService => _authService;
  CilaluRepository get repository => _repository;

  // Authentication & Role
  bool _isAuthenticated = false;
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
      adminUid: 'admin-sarah-default',
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

  // Real-time stream subscriptions
  StreamSubscription<List<ChatMessage>>? _chatSubscription;
  StreamSubscription<List<NotificationItem>>? _notifsSubscription;
  StreamSubscription<List<JoinRequest>>? _joinRequestsSubscription;

  AppStateController({
    CilaluRepository? repository,
    AuthService? authService,
  })  : _repository = repository ?? CilaluRepository(),
        _authService = authService ?? AuthService() {
    _currentCompany = _companies.first;
  }

  // ─────────────────────────────────────────────────────────────
  //  LIFECYCLE & INITIALIZATION
  // ─────────────────────────────────────────────────────────────

  Future<void> initStorage() async {
    await _repository.init();

    // 1. Load companies
    final savedCompanies = await _repository.getCompanies();
    if (savedCompanies.isNotEmpty) {
      _companies = savedCompanies;
    }

    // 2. Load active company code
    final activeCode = await _repository.loadCurrentCompanyCode();
    if (activeCode != null) {
      final found = _companies.firstWhere(
        (c) => c.code.toUpperCase() == activeCode.toUpperCase(),
        orElse: () => _companies.first,
      );
      _currentCompany = found;
    } else {
      _currentCompany = _companies.first;
    }

    // 3. Load Join Requests
    final savedRequests = await _repository.getJoinRequests(_currentCompany.code);
    if (savedRequests.isNotEmpty) {
      _joinRequests = savedRequests;
    }

    // 4. Load Auth / Session
    final session = await _repository.loadSession();
    _isAuthenticated = session['isAuthenticated'] as bool? ?? false;
    _currentUserRole = session['role'] as UserRole? ?? UserRole.admin;
    _customUserAvatar = session['customAvatar'] as String?;
    final savedEmpId = session['employeeId'] as String?;

    // 5. Load Company Data sequentially
    await _loadCompanyData(_currentCompany.code, savedEmpId: savedEmpId);

    _isStorageLoaded = true;
    notifyListeners();
  }

  Future<void> _loadCompanyData(String companyCode, {String? savedEmpId}) async {
    _isLoadingCompanyData = true;
    _cancelSubscriptions();

    try {
      // 1. Fetch domain data sequentially via repository (remote SoT with local cache fallback)
      final loadedTasks = await _repository.getTasks(companyCode);
      if (loadedTasks.isNotEmpty || companyCode != 'CILALU-88') {
        _tasks = loadedTasks;
      }

      final loadedSops = await _repository.getSops(companyCode);
      if (loadedSops.isNotEmpty || companyCode != 'CILALU-88') {
        _sops = loadedSops;
      }

      final loadedMembers = await _repository.getMembers(companyCode);
      if (loadedMembers.isNotEmpty || companyCode != 'CILALU-88') {
        _employees = loadedMembers;
      }

      final loadedChannels = await _repository.getChannels(companyCode);
      if (loadedChannels.isNotEmpty) {
        _channels = loadedChannels;
      }

      final loadedMessages = await _repository.getMessages(companyCode);
      if (loadedMessages.isNotEmpty || companyCode != 'CILALU-88') {
        _messages = loadedMessages;
      }

      final loadedNotifs = await _repository.getNotifications(companyCode);
      if (loadedNotifs.isNotEmpty || companyCode != 'CILALU-88') {
        _notifications = loadedNotifs;
      }

      final loadedRequests = await _repository.getJoinRequests(companyCode);
      if (loadedRequests.isNotEmpty || companyCode != 'CILALU-88') {
        _joinRequests = loadedRequests;
      }

      if (savedEmpId != null && _employees.isNotEmpty) {
        _currentEmployee = _employees.firstWhere(
          (e) => e.id == savedEmpId,
          orElse: () => _employees.first,
        );
      }

      // 2. Start real-time subscriptions for the active company
      _startSubscriptions(companyCode);
    } catch (e) {
      debugPrint('Error loading company data: $e');
    } finally {
      _isLoadingCompanyData = false;
      notifyListeners();
    }
  }

  void _cancelSubscriptions() {
    _chatSubscription?.cancel();
    _chatSubscription = null;
    _notifsSubscription?.cancel();
    _notifsSubscription = null;
    _joinRequestsSubscription?.cancel();
    _joinRequestsSubscription = null;
  }

  void _startSubscriptions(String companyCode) {
    _cancelSubscriptions();
    if (!_repository.isCloudAvailable) return;

    // Chat stream
    _chatSubscription = _repository.streamMessages(companyCode).listen(
      (messages) {
        if (messages.isNotEmpty) {
          _messages = messages;
          notifyListeners();
        }
      },
      onError: (e) => debugPrint('Chat subscription error: $e'),
    );

    // Notifications stream
    _notifsSubscription = _repository.streamNotifications(companyCode).listen(
      (notifs) {
        if (notifs.isNotEmpty) {
          _notifications = notifs;
          notifyListeners();
        }
      },
      onError: (e) => debugPrint('Notification subscription error: $e'),
    );

    // Join requests stream for admin
    if (isAdmin) {
      _joinRequestsSubscription = _repository.streamJoinRequests(companyCode).listen(
        (requests) {
          _joinRequests = requests;
          notifyListeners();
        },
        onError: (e) => debugPrint('Join requests subscription error: $e'),
      );
    }
  }

  void _persistSession() {
    _repository.saveSession(
      isAuthenticated: _isAuthenticated,
      role: _currentUserRole,
      employeeId: _currentEmployee?.id,
      customAvatar: _customUserAvatar,
      userId: _authService.currentUid,
      userEmail: _authService.currentEmail,
    );
  }

  void _persistCompanies() {
    _repository.saveCompany(_currentCompany);
  }

  UserRole get currentRole => _currentUserRole;
  String get currentUserDivision =>
      _currentUserRole == UserRole.admin ? _currentUser.division : (_currentEmployee?.division ?? 'Operasional');

  void updateUserAvatar(String newAvatar) {
    _customUserAvatar = newAvatar;
    _persistSession();
    notifyListeners();
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
      senderName: 'Budi Santoso',
      senderAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Staf Operasional',
      content: 'Siap Bu Sarah, tim gudang Cikarang sedang menyelesaikan checklist Pallet B4. Dokumen SOP sudah saya baca dan konfirmasi.',
      time: '08:45',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    ),
    ChatMessage(
      id: 'msg-3',
      channelId: 'ch-ops',
      senderId: 'emp-1',
      senderName: 'Budi Santoso',
      senderAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Staf Operasional',
      content: 'Laporan forklift: Unit 2 baterai 100%, siap untuk pemindahan material rack A12.',
      time: '09:00',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    ChatMessage(
      id: 'msg-4',
      channelId: 'ch-it',
      senderId: 'emp-3',
      senderName: 'Kevin Maulana',
      senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Tech Lead / DevOps',
      content: 'Update migrasi AWS DMS: CDC replication aktif, lag 0 detik. Database server berjalan optimal.',
      time: '09:30',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ChatMessage(
      id: 'msg-5',
      channelId: 'ch-marketing',
      senderId: 'emp-2',
      senderName: 'Nadia Salsabila',
      senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Desainer Grafis',
      content: 'Master banner Mid-Year Sale sudah saya kirimkan di folder Google Drive, mohon review tim lead.',
      time: '09:40',
      timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
    ),
    ChatMessage(
      id: 'msg-6',
      channelId: 'ch-finance',
      senderId: 'emp-4',
      senderName: 'Rina Kusuma',
      senderAvatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&q=80&w=256',
      senderRole: 'Finance & Tax Officer',
      content: 'Draft SPT Masa PPh 21 sudah direkonsiliasi. Pengajuan reimbursement staf diproses siang ini.',
      time: '09:55',
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
  ];

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  UserRole get currentUserRole => _currentUserRole;
  Assignee? get currentEmployee => _currentEmployee;
  bool get isAdmin => _currentUserRole == UserRole.admin;
  bool get isUser => _currentUserRole == UserRole.user;

  String get currentUserName => isAdmin ? _currentCompany.adminName : (_currentEmployee?.name ?? _currentUser.name);
  String get currentUserEmail => isAdmin ? _currentCompany.adminEmail : (_currentEmployee?.email ?? _currentUser.email);
  String get currentUserRoleTitle => isAdmin ? 'Admin / Manager' : (_currentEmployee?.role ?? _currentUser.role);
  String get currentUserAvatar => _customUserAvatar ?? (isAdmin
      ? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=256'
      : (_currentEmployee?.avatar ?? _currentUser.avatar));

  void updateCustomAvatar(String url) {
    _customUserAvatar = url;
    _persistSession();
    notifyListeners();
  }

  List<Company> get companies => List.unmodifiable(_companies);
  Company get currentCompany => _currentCompany;
  List<JoinRequest> get joinRequests => List.unmodifiable(_joinRequests);
  List<JoinRequest> get pendingJoinRequests =>
      _joinRequests.where((r) => r.status == JoinRequestStatus.pending && r.companyCode.toUpperCase() == _currentCompany.code.toUpperCase()).toList();
  int get pendingJoinRequestsCount => pendingJoinRequests.length;
  bool get isBlankMode => _isBlankMode;

  // ─────────────────────────────────────────────────────────────
  //  COMPANY SWITCHING & SEQUENTIAL LOADING
  // ─────────────────────────────────────────────────────────────

  Future<void> switchCompany(Company comp) async {
    _currentCompany = comp;

    // 1. Immediately clear in-memory lists to prevent data leaks across companies
    _tasks = [];
    _sops = [];
    _employees = [];
    _messages = [];
    _notifications = [];
    _activities = [];
    _isLoadingCompanyData = true;
    notifyListeners();

    // 2. Persist active code and load target company data sequentially
    await _repository.saveCurrentCompanyCode(_currentCompany.code);
    await _loadCompanyData(_currentCompany.code);
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

    _repository.pushNotification(_currentCompany.code, item);
    notifyListeners();
  }

  void dismissActiveNotification() {
    _inAppBannerTimer?.cancel();
    _inAppBannerTimer = null;
    _activeInAppNotification = null;
    notifyListeners();
  }

  // Multi-Company Management
  Future<void> registerCompany({
    required String name,
    required String code,
    required String adminName,
    required String adminEmail,
    required String adminPassword,
    String industry = 'Teknologi & Operasional',
  }) async {
    final cleanCode = code.trim().toUpperCase();
    final cleanEmail = adminEmail.trim();

    String adminUid = 'admin-${DateTime.now().millisecondsSinceEpoch}';
    if (_authService.isAvailable) {
      try {
        final cred = await _authService.signUp(
          email: cleanEmail,
          password: adminPassword,
        );
        adminUid = cred.user?.uid ?? adminUid;
      } catch (e) {
        try {
          final cred = await _authService.signIn(
            email: cleanEmail,
            password: adminPassword,
          );
          adminUid = cred.user?.uid ?? adminUid;
        } catch (_) {
          rethrow;
        }
      }
    }

    final newComp = Company(
      id: 'comp-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      code: cleanCode,
      adminName: adminName.trim(),
      adminEmail: cleanEmail,
      adminUid: adminUid,
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

    final welcomeNotif = NotificationItem(
      id: 'notif-welcome-${DateTime.now().millisecondsSinceEpoch}',
      title: '🏢 Perusahaan ${newComp.name} Berhasil Dibuat!',
      description: 'ID Perusahaan Anda: $cleanCode. Bagikan ke karyawan agar mereka dapat bergabung.',
      time: 'Baru saja',
      type: 'system',
      targetTab: 5,
      timestamp: DateTime.now(),
    );
    pushNotification(welcomeNotif, showBanner: true);

    await _repository.saveCompany(newComp);
    await _repository.saveChannels(newComp.code, _channels);
    _persistSession();
    notifyListeners();
  }

  Future<JoinRequest> submitJoinRequest({
    required String companyCode,
    required String name,
    required String email,
    required String password,
    required String division,
    required String role,
  }) async {
    final cleanCode = companyCode.trim().toUpperCase();
    final cleanEmail = email.trim();

    String userId = 'user-${DateTime.now().millisecondsSinceEpoch}';
    if (_authService.isAvailable) {
      try {
        final cred = await _authService.signUp(
          email: cleanEmail,
          password: password,
        );
        userId = cred.user?.uid ?? userId;
      } catch (e) {
        try {
          final cred = await _authService.signIn(
            email: cleanEmail,
            password: password,
          );
          userId = cred.user?.uid ?? userId;
        } catch (_) {
          rethrow;
        }
      }
    }

    final targetComp = _companies.firstWhere(
      (c) => c.code.toUpperCase() == cleanCode,
      orElse: () => Company(
        id: 'comp-ext',
        name: 'Perusahaan $cleanCode',
        code: cleanCode,
        adminName: 'Admin Perusahaan',
        adminEmail: 'admin@${cleanCode.toLowerCase()}.id',
        adminUid: '',
        createdAt: DateTime.now(),
      ),
    );

    final req = JoinRequest(
      id: 'req-${DateTime.now().millisecondsSinceEpoch}',
      companyCode: cleanCode,
      companyName: targetComp.name,
      userId: userId,
      userName: name.trim(),
      userEmail: cleanEmail,
      division: division.trim(),
      role: role.trim(),
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=256',
      status: JoinRequestStatus.pending,
      requestedAt: DateTime.now(),
    );

    _joinRequests = [req, ..._joinRequests];

    final notif = NotificationItem(
      id: 'notif-join-${DateTime.now().millisecondsSinceEpoch}',
      title: '👥 Permintaan Bergabung Baru!',
      description: '${req.userName} memohon bergabung ke divisi ${req.division} ($cleanCode).',
      time: 'Baru saja',
      type: 'system',
      targetTab: 5,
      timestamp: DateTime.now(),
    );
    pushNotification(notif, showBanner: true);

    await _repository.submitJoinRequest(cleanCode, req);
    notifyListeners();
    return req;
  }

  Future<void> acceptJoinRequest(String requestId) async {
    final found = _joinRequests.where((r) => r.id == requestId).firstOrNull;
    if (found == null) return;

    final acceptedReq = found.copyWith(status: JoinRequestStatus.approved);
    final newEmp = Assignee(
      id: acceptedReq.userId.isNotEmpty
          ? acceptedReq.userId
          : 'emp-${DateTime.now().millisecondsSinceEpoch}',
      name: acceptedReq.userName,
      shortName: acceptedReq.userName.split(' ').first,
      avatar: acceptedReq.avatar,
      division: acceptedReq.division,
      role: acceptedReq.role,
      hasTeamBadge: true,
      teamCount: 1,
      email: acceptedReq.userEmail,
    );

    final welcomeNotif = NotificationItem(
      id: 'notif-member-${DateTime.now().millisecondsSinceEpoch}',
      title: '🎉 Anggota Tim Baru Bergabung!',
      description: '${newEmp.name} resmi bergabung ke divisi ${newEmp.division}.',
      time: 'Baru saja',
      type: 'system',
      targetTab: 5,
      timestamp: DateTime.now(),
    );

    _joinRequests = _joinRequests.map((r) => r.id == requestId ? acceptedReq : r).toList();
    _employees = [..._employees, newEmp];
    pushNotification(welcomeNotif, showBanner: true);

    try {
      await _repository.acceptJoinRequestBatch(
        companyCode: _currentCompany.code,
        request: acceptedReq,
        member: newEmp,
        welcomeNotif: welcomeNotif,
      );
    } catch (e) {
      debugPrint('acceptJoinRequest error: $e');
    }
    notifyListeners();
  }

  Future<void> rejectJoinRequest(String requestId) async {
    _joinRequests = _joinRequests.map((r) {
      if (r.id == requestId) {
        return r.copyWith(status: JoinRequestStatus.rejected);
      }
      return r;
    }).toList();

    await _repository.deleteJoinRequest(_currentCompany.code, requestId);
    notifyListeners();
  }

  void resetToInitialData() {
    _tasks = [];
    _sops = [];
    _activities = [];
    _notifications = [];
    _employees = [];
    notifyListeners();
  }

  void loadSampleDemoData() {
    _tasks = List.from(kInitialTasks);
    _sops = List.from(kInitialSops);
    _activities = List.from(kInitialActivities);
    _notifications = List.from(kNotificationsData);
    _employees = List.from(kEmployees);
    notifyListeners();
  }

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

  List<ChatMessage> messagesForChannel(String? channelId) {
    if (channelId == null) return _messages;
    return _messages.where((m) => m.channelId == channelId).toList();
  }

  void addChannel(String name, String description) {
    final newCh = ChatChannel(
      id: 'ch-${DateTime.now().millisecondsSinceEpoch}',
      name: name.startsWith('#') ? name : '#$name',
      description: description,
      lastMessage: 'Saluran baru dibuat.',
      lastMessageTime: 'Baru saja',
      unreadCount: 0,
    );
    _channels = [..._channels, newCh];
    _repository.saveChannels(_currentCompany.code, _channels);
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────
  //  AUTH & SESSION CONTROLS
  // ─────────────────────────────────────────────────────────────

  Future<void> loginWithCredentials({
    required String companyCode,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final cleanCode = companyCode.trim().toUpperCase();
    final cleanEmail = email.trim();

    // 1. Verify Company Existence
    final foundCompany = _companies.where(
      (c) => c.code.toUpperCase() == cleanCode,
    ).firstOrNull;

    if (foundCompany == null) {
      throw Exception('ID Perusahaan "$cleanCode" tidak ditemukan.');
    }

    // 2. Authenticate with Firebase Auth if available
    String uid = 'uid-${cleanEmail.hashCode}';
    if (_authService.isAvailable) {
      final cred = await _authService.signIn(email: cleanEmail, password: password);
      uid = cred.user?.uid ?? uid;
    }

    // 3. Verify Membership and Role Authorization
    if (role == UserRole.admin) {
      final isAdmin = foundCompany.adminEmail.toLowerCase() == cleanEmail.toLowerCase() ||
          (foundCompany.adminUid.isNotEmpty && foundCompany.adminUid == uid);
      if (!isAdmin) {
        throw Exception('Akun ini tidak memiliki hak akses sebagai Administrator di $cleanCode.');
      }
      _currentCompany = foundCompany;
      _currentUserRole = UserRole.admin;
      _currentEmployee = null;
    } else {
      if (foundCompany.code != _currentCompany.code) {
        _currentCompany = foundCompany;
      }
      await _loadCompanyData(foundCompany.code);
      final emp = _employees.where((e) =>
          e.email.toLowerCase() == cleanEmail.toLowerCase() || e.id == uid).firstOrNull;
      if (emp == null) {
        throw Exception('Akun Anda belum terdaftar sebagai anggota di $cleanCode. Silakan ajukan melalui "Gabung Tim".');
      }
      _currentUserRole = UserRole.user;
      _currentEmployee = emp;
    }

    _isAuthenticated = true;
    _currentTabIndex = 0;
    _persistSession();
    _persistCompanies();
    notifyListeners();
  }

  void loginAsAdmin({Company? company}) {
    if (company != null) {
      _currentCompany = company;
    }
    _currentUserRole = UserRole.admin;
    _currentEmployee = null;
    _isAuthenticated = true;
    _currentTabIndex = 0;
    _persistSession();
    _persistCompanies();
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
    _persistSession();
    _persistCompanies();
    notifyListeners();
  }

  Future<void> logout() async {
    _cancelSubscriptions();

    if (_authService.isAvailable) {
      await _authService.signOut();
    }
    _isAuthenticated = false;
    _currentUserRole = UserRole.admin;
    _currentEmployee = null;
    _currentTabIndex = 0;
    _activeInAppNotification = null;

    // Reset sensitive in-memory data completely to prevent lingering leaks across accounts
    _tasks = [];
    _sops = [];
    _employees = [];
    _channels = [];
    _messages = [];
    _notifications = [];
    _activities = [];

    await _repository.clearSession();
    notifyListeners();
  }

  void setTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  TASK METHODS (Granular CRUD + Deletion)
  // ─────────────────────────────────────────────────────────────

  Future<void> createTask(Task newTask) async {
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

    notifyListeners();
    try {
      await _repository.createTask(_currentCompany.code, newTask);
    } catch (e) {
      debugPrint('createTask repository error: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (!isAdmin) return;
    _tasks = _tasks.where((t) => t.id != taskId).toList();
    notifyListeners();

    try {
      await _repository.deleteTask(_currentCompany.code, taskId);
    } catch (e) {
      debugPrint('deleteTask repository error: $e');
    }
  }

  Future<void> saveProgress(String taskId, List<Subtask> updatedSubtasks, int progressPercent) async {
    Task? target;
    _tasks = _tasks.map((t) {
      if (t.id == taskId) {
        final isDone = progressPercent == 100;
        target = t.copyWith(
          subtasks: updatedSubtasks,
          progressPercent: progressPercent,
          status: isDone ? TaskStatus.completed : TaskStatus.inProgress,
          needsReview: isDone ? true : t.needsReview,
        );
        return target!;
      }
      return t;
    }).toList();

    if (target != null) {
      final newActivity = ActivityItem(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        userName: currentUserName,
        userAvatar: currentUserAvatar,
        actionPrefix: 'memperbarui progres tugas',
        targetObject: target!.title,
        actionSuffix: 'ke $progressPercent%.',
        timeAgo: 'Baru saja',
        department: target!.division,
        type: 'task',
      );
      _activities = [newActivity, ..._activities];

      pushNotification(
        NotificationItem(
          id: 'notif-prog-${DateTime.now().millisecondsSinceEpoch}',
          title: '📈 Progres Tugas Diperbarui ($progressPercent%)',
          description: '$currentUserName memperbarui "${target!.title}" ke $progressPercent%.',
          time: 'Baru saja',
          type: 'task',
          targetTab: 1,
          targetId: target!.id,
          timestamp: DateTime.now(),
        ),
        showBanner: true,
      );

      notifyListeners();
      try {
        await _repository.updateTask(_currentCompany.code, target!);
      } catch (e) {
        debugPrint('saveProgress repository error: $e');
      }
    }
  }

  Future<void> approveTask(String taskId) async {
    if (!isAdmin) return;

    Task? target;
    _tasks = _tasks.map((t) {
      if (t.id == taskId) {
        target = t.copyWith(
          status: TaskStatus.completed,
          progressPercent: 100,
          subtasks: t.subtasks.map((st) => st.copyWith(completed: true)).toList(),
          needsReview: false,
        );
        return target!;
      }
      return t;
    }).toList();

    if (target != null) {
      final newActivity = ActivityItem(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        userName: currentUserName,
        userAvatar: currentUserAvatar,
        actionPrefix: 'menyetujui & menyelesaikan tugas',
        targetObject: target!.title,
        timeAgo: 'Baru saja',
        department: target!.division,
        type: 'task',
      );
      _activities = [newActivity, ..._activities];

      pushNotification(
        NotificationItem(
          id: 'notif-appr-${DateTime.now().millisecondsSinceEpoch}',
          title: '✅ Tugas Telah Disetujui & Selesai',
          description: 'Sarah Pratama telah menyetujui tugas "${target!.title}".',
          time: 'Baru saja',
          type: 'review',
          targetTab: 1,
          targetId: target!.id,
          timestamp: DateTime.now(),
        ),
        showBanner: true,
      );

      notifyListeners();
      try {
        await _repository.updateTask(_currentCompany.code, target!);
      } catch (e) {
        debugPrint('approveTask repository error: $e');
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  SOP METHODS (Granular CRUD + Deletion)
  // ─────────────────────────────────────────────────────────────

  Future<void> addSop(SOPDocument newSop) async {
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
        title: '📑 SOP Baru: ${newSop.code}',
        description: '${newSop.title} telah diterbitkan dan wajib dipatuhi.',
        time: 'Baru saja',
        type: 'sop',
        targetTab: 2,
        targetId: newSop.id,
        timestamp: DateTime.now(),
      ),
      showBanner: true,
    );

    notifyListeners();
    try {
      await _repository.createSop(_currentCompany.code, newSop);
    } catch (e) {
      debugPrint('addSop repository error: $e');
    }
  }

  Future<void> deleteSop(String sopId) async {
    if (!isAdmin) return;
    _sops = _sops.where((s) => s.id != sopId).toList();
    notifyListeners();

    try {
      await _repository.deleteSop(_currentCompany.code, sopId);
    } catch (e) {
      debugPrint('deleteSop repository error: $e');
    }
  }

  Future<void> confirmReadSop(String sopId) async {
    SOPDocument? target;
    _sops = _sops.map((s) {
      if (s.id == sopId) {
        target = s.copyWith(isReadByMe: true);
        return target!;
      }
      return s;
    }).toList();

    final sop = target ?? _sops.firstWhere((s) => s.id == sopId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: currentUserName,
      userAvatar: currentUserAvatar,
      actionPrefix: 'mengonfirmasi membaca',
      targetObject: sop.code,
      timeAgo: 'Baru saja',
      department: sop.category,
      type: 'sop',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
    if (target != null) {
      try {
        await _repository.updateSop(_currentCompany.code, target!);
      } catch (e) {
        debugPrint('confirmReadSop repository error: $e');
      }
    }
  }

  Future<void> toggleBookmarkSop(String sopId) async {
    SOPDocument? target;
    _sops = _sops.map((s) {
      if (s.id == sopId) {
        target = s.copyWith(isBookmarked: !s.isBookmarked);
        return target!;
      }
      return s;
    }).toList();

    notifyListeners();
    if (target != null) {
      try {
        await _repository.updateSop(_currentCompany.code, target!);
      } catch (e) {
        debugPrint('toggleBookmarkSop repository error: $e');
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  BROADCAST & NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────

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

  Future<void> deleteNotification(String notifId) async {
    _notifications = _notifications.where((n) => n.id != notifId).toList();
    notifyListeners();
    await _repository.deleteNotification(_currentCompany.code, notifId);
  }

  Future<void> clearAllNotifications() async {
    final ids = _notifications.map((n) => n.id).toList();
    _notifications = [];
    notifyListeners();
    await _repository.clearAllNotifications(_currentCompany.code, ids);
  }

  // ─────────────────────────────────────────────────────────────
  //  CHAT METHODS (Granular CRUD + Deletion)
  // ─────────────────────────────────────────────────────────────

  Future<void> sendChatMessage({
    required String content,
    String? channelId,
    String? receiverId,
  }) async {
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

    notifyListeners();

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

    try {
      await _repository.sendMessage(_currentCompany.code, newMsg);
      await _repository.saveChannels(_currentCompany.code, _channels);
    } catch (e) {
      debugPrint('sendChatMessage repository error: $e');
    }
  }

  Future<void> deleteChatMessage(String messageId) async {
    _messages = _messages.where((m) => m.id != messageId).toList();
    notifyListeners();
    try {
      await _repository.deleteMessage(_currentCompany.code, messageId);
    } catch (e) {
      debugPrint('deleteChatMessage repository error: $e');
    }
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
    ];

    final event = events[_simIndex % events.length];
    _simIndex++;
    pushNotification(event, showBanner: true);
  }

  bool _isDisposed = false;

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _inAppBannerTimer?.cancel();
    _cancelSubscriptions();
    super.dispose();
  }
}
