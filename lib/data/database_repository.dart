import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_manager.dart';

class DatabaseRepository {
  static const String _sessionsKey = 'user_sessions';

  Future<int> createSession({
    required String name,
    required bool reminder,
    String? date,
    String? time,
    required int totalMinutes,
    required List<String> stepTitles,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getAllSessions();

    final newSession = SavedSession(
      name: name,
      reminder: reminder,
      date: date ?? '',
      time: time ?? '',
      totalMinutes: totalMinutes,
      stepTitles: stepTitles,
    );

    sessions.add(newSession);
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_sessionsKey, encoded);

    print('✅ Сессия сохранена: $name');
    return sessions.length;
  }

  Future<List<SavedSession>> getAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_sessionsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((item) => SavedSession.fromJson(item)).toList();
  }

  Future<void> deleteAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionsKey);
    print('✅ Все сессии удалены');
  }
}