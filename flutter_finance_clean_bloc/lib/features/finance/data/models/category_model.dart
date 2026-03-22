import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/category.dart';

class CategoryModel {
  static Category fromMap(Map data) {
    return Category(
      id: data['id'],
      name: data['name'],
    );
  }
}