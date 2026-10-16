import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/company.dart';
import '../models/task.dart';
import '../models/sop.dart';
import '../models/employee.dart';
import '../models/chat_model.dart';
import '../models/notification_item.dart';

/// Cloud Firestore service for real-time multi-device sync.
/// Mirrors the LocalStorageService structure but persists to Firebase cloud.
/// All data is partitioned by company code for multi-tenant isolation.
class FirestoreService {
  static FirestoreService? _instance;
  factory FirestoreService() => _instance ??= FirestoreService._();
  FirestoreService._();

  // Lazy — only accessed after Firebase.initializeApp() succeeds
  FirebaseFirestore? _db;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  /// Check if Firestore is reachable and mark as available
  Future<void> init() async {
    try {
      _db = FirebaseFirestore.instance;
      // Quick connectivity check — read a small doc
      await _db!
          .collection('_ping')
          .doc('status')
          .get()
          .timeout(const Duration(seconds: 5));
      _isAvailable = true;
      debugPrint('☁️ Firestore: Connected and ready');
    } catch (e) {
      _isAvailable = false;
      debugPrint('☁️ Firestore: Offline mode — $e');
    }
  }

  // ───────────────────────────────────────────────────
  //  Companies (Global Collection)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _companiesRef =>
      _db!.collection('companies');

  Future<void> saveCompany(Company company) async {
    if (!_isAvailable) return;
    try {
      await _companiesRef.doc(company.code).set(company.toMap());
    } catch (e) {
      debugPrint('Firestore saveCompany error: $e');
    }
  }

  Future<List<Company>> loadCompanies() async {
    if (!_isAvailable) return [];
    try {
      final snap = await _companiesRef.get();
      return snap.docs.map((doc) => Company.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadCompanies error: $e');
      return [];
    }
  }

  Future<Company?> loadCompanyByCode(String code) async {
    if (!_isAvailable) return null;
    try {
      final doc = await _companiesRef.doc(code).get();
      if (doc.exists && doc.data() != null) {
        return Company.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint('Firestore loadCompanyByCode error: $e');
    }
    return null;
  }

  // ───────────────────────────────────────────────────
  //  Tasks (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _tasksRef(String companyCode) =>
      _companiesRef.doc(companyCode).collection('tasks');

  Future<void> saveTasks(String companyCode, List<Task> tasks) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final task in tasks) {
        batch.set(_tasksRef(companyCode).doc(task.id), task.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveTasks error: $e');
    }
  }

  Future<List<Task>> loadTasks(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _tasksRef(companyCode).get();
      return snap.docs.map((doc) => Task.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadTasks error: $e');
      return [];
    }
  }

  // ───────────────────────────────────────────────────
  //  SOPs (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _sopsRef(String companyCode) =>
      _companiesRef.doc(companyCode).collection('sops');

  Future<void> saveSops(String companyCode, List<SOPDocument> sops) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final sop in sops) {
        batch.set(_sopsRef(companyCode).doc(sop.id), sop.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveSops error: $e');
    }
  }

  Future<List<SOPDocument>> loadSops(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _sopsRef(companyCode).get();
      return snap.docs.map((doc) => SOPDocument.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadSops error: $e');
      return [];
    }
  }

  // ───────────────────────────────────────────────────
  //  Employees / Members (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _membersRef(String companyCode) =>
      _companiesRef.doc(companyCode).collection('members');

  Future<void> saveEmployees(
    String companyCode,
    List<Assignee> employees,
  ) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final emp in employees) {
        batch.set(_membersRef(companyCode).doc(emp.id), emp.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveEmployees error: $e');
    }
  }

  Future<List<Assignee>> loadEmployees(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _membersRef(companyCode).get();
      return snap.docs.map((doc) => Assignee.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadEmployees error: $e');
      return [];
    }
  }

  // ───────────────────────────────────────────────────
  //  Chat Channels (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _channelsRef(String companyCode) =>
      _companiesRef.doc(companyCode).collection('channels');

  Future<void> saveChannels(
    String companyCode,
    List<ChatChannel> channels,
  ) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final ch in channels) {
        batch.set(_channelsRef(companyCode).doc(ch.id), ch.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveChannels error: $e');
    }
  }

  Future<List<ChatChannel>> loadChannels(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _channelsRef(companyCode).get();
      return snap.docs.map((doc) => ChatChannel.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadChannels error: $e');
      return [];
    }
  }

  // ───────────────────────────────────────────────────
  //  Chat Messages (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _messagesRef(String companyCode) =>
      _companiesRef.doc(companyCode).collection('messages');

  Future<void> saveMessage(String companyCode, ChatMessage message) async {
    if (!_isAvailable) return;
    try {
      await _messagesRef(companyCode).doc(message.id).set(message.toMap());
    } catch (e) {
      debugPrint('Firestore saveMessage error: $e');
    }
  }

  Future<void> saveMessages(
    String companyCode,
    List<ChatMessage> messages,
  ) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final msg in messages) {
        batch.set(_messagesRef(companyCode).doc(msg.id), msg.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveMessages error: $e');
    }
  }

  Future<List<ChatMessage>> loadMessages(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _messagesRef(companyCode).orderBy('timestamp').get();
      return snap.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadMessages error: $e');
      return [];
    }
  }

  /// Listen to new messages in real-time for a company
  Stream<List<ChatMessage>> messagesStream(String companyCode) {
    if (!_isAvailable || _db == null) return const Stream.empty();
    return _messagesRef(companyCode)
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList(),
        );
  }

  // ───────────────────────────────────────────────────
  //  Join Requests (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _joinRequestsRef(
    String companyCode,
  ) => _companiesRef.doc(companyCode).collection('join_requests');

  Future<void> saveJoinRequest(String companyCode, JoinRequest request) async {
    if (!_isAvailable) return;
    try {
      await _joinRequestsRef(companyCode).doc(request.id).set(request.toMap());
    } catch (e) {
      debugPrint('Firestore saveJoinRequest error: $e');
    }
  }

  Future<void> saveJoinRequests(
    String companyCode,
    List<JoinRequest> requests,
  ) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final req in requests) {
        batch.set(_joinRequestsRef(companyCode).doc(req.id), req.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveJoinRequests error: $e');
    }
  }

  Future<List<JoinRequest>> loadJoinRequests(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _joinRequestsRef(companyCode).get();
      return snap.docs.map((doc) => JoinRequest.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Firestore loadJoinRequests error: $e');
      return [];
    }
  }

  /// Listen to new join requests in real-time for admin notifications
  Stream<List<JoinRequest>> joinRequestsStream(String companyCode) {
    if (!_isAvailable || _db == null) return const Stream.empty();
    return _joinRequestsRef(companyCode).snapshots().map(
      (snap) =>
          snap.docs.map((doc) => JoinRequest.fromMap(doc.data())).toList(),
    );
  }

  // ───────────────────────────────────────────────────
  //  Notifications (Sub-collection per company)
  // ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _notifsRef(String companyCode) =>
      _companiesRef.doc(companyCode).collection('notifications');

  Future<void> saveNotifications(
    String companyCode,
    List<NotificationItem> notifs,
  ) async {
    if (!_isAvailable) return;
    try {
      final batch = _db!.batch();
      for (final n in notifs) {
        batch.set(_notifsRef(companyCode).doc(n.id), n.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore saveNotifications error: $e');
    }
  }

  Future<List<NotificationItem>> loadNotifications(String companyCode) async {
    if (!_isAvailable) return [];
    try {
      final snap = await _notifsRef(companyCode).get();
      return snap.docs
          .map((doc) => NotificationItem.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Firestore loadNotifications error: $e');
      return [];
    }
  }
}
