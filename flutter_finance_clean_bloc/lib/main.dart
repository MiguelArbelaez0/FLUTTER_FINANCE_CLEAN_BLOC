import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';
import 'core/database/local_database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  Intl.defaultLocale = 'es_CO';
  await LocalDatabaseService.instance.init();
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
