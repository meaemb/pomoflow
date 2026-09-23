import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/tip_model.dart';

class TipApiService {
  // API для цитат (оставляем как есть)
  static const String adviceApiUrl = 'https://api.adviceslip.com';

  // ТВОЙ НОВЫЙ API НА GITHUB!
  static const String myApiBaseUrl = 'https://my-json-server.typicode.com/meaemb/pomoflow-api';

  Future<String> fetchRandomTip() async {
    try {
      final url = Uri.parse('$adviceApiUrl/advice');
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API returned: ${data['slip']['advice']}');
        return data['slip']['advice'];
      } else {
        print('API error: ${response.statusCode}');
        return '';
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      return '';
    } on TimeoutException catch (e) {
      print('Timeout: $e');
      return '';
    } catch (e) {
      print('Other error: $e');
      return '';
    }
  }

  // НОВЫЙ МЕТОД: получение советов из твоего API на GitHub
  Future<List<TipModel>> fetchAllTipsFromMyApi() async {
    try {
      final url = Uri.parse('$myApiBaseUrl/tips');
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('✅ Загружено ${data.length} советов из API');
        return data.map((json) => TipModel.fromJson(json)).toList();
      } else {
        print('❌ Ошибка API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Ошибка сети: $e');
      return [];
    }
  }

  // Поиск советов (фильтруем на клиенте)
  Future<List<TipModel>> searchTips(String query) async {
    final allTips = await fetchAllTipsFromMyApi();
    return allTips.where((tip) =>
    tip.name.toLowerCase().contains(query.toLowerCase()) ||
        tip.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // СТАРЫЙ МЕТОД (оставляем на всякий случай, но не используем)
  Future<List<Map<String, dynamic>>> fetchTipsFromMockApi() async {
    // Лучше использовать fetchAllTipsFromMyApi()
    return [];
  }
}