import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tip_model.dart';

class TipLoader {
  static Future<List<TipModel>> loadTipsFromJson() async {
    // Загружаем JSON файл из assets
    final jsonString = await rootBundle.loadString('assets/data/tips.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final List<dynamic> tipsJson = jsonMap['tips'];

    return tipsJson.map((json) => TipModel.fromJson(json)).toList();
  }
}