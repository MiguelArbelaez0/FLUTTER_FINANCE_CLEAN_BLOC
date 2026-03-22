import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<Box> openBox(String name) async {
    return await Hive.openBox(name);
  }
}
