import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/core/utils/local_database_service.dart';
import 'app/app.dart';
import 'app/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = LocalDatabaseService();
  try {
    await databaseService.init();
  } catch (_) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'No se pudo abrir el almacenamiento local. Reinicia la aplicación para reintentar.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    return;
  }

  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
