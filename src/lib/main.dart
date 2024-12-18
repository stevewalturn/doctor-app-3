import 'package:flutter/material.dart';
import 'package:my_app/app/app.bottomsheets.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/ui/theme/app_theme.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupBottomSheetUi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.lightTheme,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
