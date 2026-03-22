import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/core/utils/local_database_service.dart';
import 'app/app.dart';
import 'app/app_bloc_observer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = LocalDatabaseService();
  await databaseService.init();

  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
