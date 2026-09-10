import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cilalutask_mobile/main.dart';
import 'package:cilalutask_mobile/state/app_state_controller.dart';
import 'package:cilalutask_mobile/models/user_role.dart';
import 'package:cilalutask_mobile/models/notification_item.dart';

void main() {
  testWidgets('Cilalutask initial launch shows LoginScreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = AppStateController();
    await tester.pumpWidget(CilalutaskApp(controller: controller));
    await tester.pumpAndSettle();

    // Verify brand header and login elements exist
    expect(find.text('CILULATAKS'), findsOneWidget);
    expect(find.text('Pilih Peran Masuk'), findsOneWidget);
    expect(find.text('Masuk sebagai Admin'), findsWidgets);
  });

  testWidgets('Logging in as Admin shows 6 navigation tabs including Chat', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = AppStateController();
    await tester.pumpWidget(CilalutaskApp(controller: controller));
    await tester.pumpAndSettle();

    // Click quick demo login as Admin
    final demoAdminFinder = find.text('Demo Admin');
    expect(demoAdminFinder, findsOneWidget);
    await tester.ensureVisible(demoAdminFinder);
    await tester.pumpAndSettle();
    await tester.tap(demoAdminFinder);
    await tester.pumpAndSettle();

    // Verify authenticated state
    expect(controller.isAuthenticated, isTrue);
    expect(controller.isAdmin, isTrue);
    expect(controller.currentRole, UserRole.admin);

    // Verify all 6 navigation tabs exist
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Tugas'), findsWidgets);
    expect(find.text('SOP'), findsWidgets);
    expect(find.text('Laporan'), findsWidgets);
    expect(find.text('Chat'), findsWidgets);
    expect(find.text('Tim & Notif'), findsWidgets);
  });

  testWidgets('Logging in as User/Karyawan has user role permissions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = AppStateController();
    await tester.pumpWidget(CilalutaskApp(controller: controller));
    await tester.pumpAndSettle();

    // Click quick demo login as Karyawan (Kevin Maulana)
    final demoUserFinder = find.text('Demo User IT');
    expect(demoUserFinder, findsOneWidget);
    await tester.ensureVisible(demoUserFinder);
    await tester.pumpAndSettle();
    await tester.tap(demoUserFinder);
    await tester.pumpAndSettle();

    // Verify user role
    expect(controller.isAuthenticated, isTrue);
    expect(controller.isUser, isTrue);
    expect(controller.isAdmin, isFalse);
    expect(controller.currentEmployee?.name, 'Kevin Maulana');

    // Switch to Chat tab (Tab 4)
    controller.setTab(4);
    await tester.pumpAndSettle();

    // Verify chat channels exist
    expect(find.text('#umum'), findsOneWidget);
    expect(find.text('#operasional-gudang'), findsOneWidget);
  });

  testWidgets('Real-time notification engine triggers heads-up banner & center bottom sheet', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final controller = AppStateController();
    await tester.pumpWidget(CilalutaskApp(controller: controller));
    await tester.pumpAndSettle();

    // Login as Admin
    final demoAdminFinder = find.text('Demo Admin');
    await tester.ensureVisible(demoAdminFinder);
    await tester.tap(demoAdminFinder);
    await tester.pumpAndSettle();

    // Dispatch a real-time notification
    controller.pushNotification(
      const NotificationItem(
        id: 'test-realtime-1',
        title: '💬 Pesan Realtime Baru',
        description: 'Kevin Maulana: Server Aurora telah aktif tanpa downtime.',
        time: 'Baru saja',
        type: 'chat',
        targetTab: 4,
      ),
      showBanner: true,
    );

    // Pump to render banner animation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify banner content is rendered
    expect(find.text('💬 Pesan Realtime Baru'), findsOneWidget);
    expect(find.text('CHAT TIM'), findsOneWidget);

    // Tap notification bell to open NotificationCenterBottomSheet
    final bellFinder = find.byIcon(Icons.notifications_none_rounded);
    expect(bellFinder, findsOneWidget);
    await tester.tap(bellFinder);
    await tester.pumpAndSettle();

    // Verify Notification Center Bottom Sheet opened
    expect(find.text('Live Real-time'), findsOneWidget);
    expect(find.text('Uji Real-time (+)'), findsOneWidget);

    // Mark all as read
    final markReadFinder = find.textContaining('Tandai Baca');
    if (markReadFinder.evaluate().isNotEmpty) {
      await tester.tap(markReadFinder.first);
      await tester.pumpAndSettle();
      expect(controller.unreadNotificationsCount, 0);
    }

    // Dismiss active notification and elapse any remaining timers
    controller.dismissActiveNotification();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
