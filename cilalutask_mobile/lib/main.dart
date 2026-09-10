import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'state/app_state_controller.dart';
import 'state/app_state_scope.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateController = AppStateController();

  runApp(CilalutaskApp(controller: appStateController));
}

class CilalutaskApp extends StatelessWidget {
  final AppStateController controller;

  const CilalutaskApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      controller: controller,
      child: MaterialApp(
        title: 'CILULATAKS Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
