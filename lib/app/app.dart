import 'package:flutter/material.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/pages/dashboard_page.dart';
import 'app_providers.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mis finanzas',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F6F8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1F4E79),
            primary: const Color(0xFF1F4E79),
            surface: Colors.white,
            error: const Color(0xFFB91C1C),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F6F8),
            foregroundColor: Color(0xFF1F2937),
            elevation: 0,
            centerTitle: false,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        home: const FinanceDashboardPage(),
      ),
    );
  }
}
