import 'package:flutter/material.dart';

import 'app_providers.dart';
import 'app_theme.dart';
import '../features/finance/presentation/pages/dashboard_page.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => AppProviders(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Finance',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const FinanceDashboardPage(),
    ),
  );
}
