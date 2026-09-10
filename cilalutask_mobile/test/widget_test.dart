import 'package:flutter_test/flutter_test.dart';
import 'package:cilalutask_mobile/main.dart';
import 'package:cilalutask_mobile/state/app_state_controller.dart';

void main() {
  testWidgets('Cilalutask smoke test', (WidgetTester tester) async {
    final controller = AppStateController();
    await tester.pumpWidget(CilalutaskApp(controller: controller));

    // Verify brand header exists
    expect(find.text('CILULATAKS'), findsOneWidget);
    expect(find.text('Beranda'), findsWidgets);
  });
}
