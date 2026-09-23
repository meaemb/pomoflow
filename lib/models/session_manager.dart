import 'dart:async';
import 'package:flutter/foundation.dart';  // ← ДОБАВИТЬ ЭТОТ ИМПОРТ!
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedSession {
  final String name;
  final bool reminder;
  final String date;
  final String time;
  final int totalMinutes;
  final List<String> stepTitles;

  SavedSession({
    required this.name,
    required this.reminder,
    required this.date,
    required this.time,
    required this.totalMinutes,
    required this.stepTitles,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'reminder': reminder,
    'date': date,
    'time': time,
    'totalMinutes': totalMinutes,
    'stepTitles': stepTitles,
  };

  factory SavedSession.fromJson(Map<String, dynamic> json) => SavedSession(
    name: json['name'],
    reminder: json['reminder'],
    date: json['date'],
    time: json['time'],
    totalMinutes: json['totalMinutes'],
    stepTitles: List<String>.from(json['stepTitles']),
  );
}

class SessionManager extends ChangeNotifier {
  List<SavedSession> _sessions = [];
  final String _sessionsKey = 'user_sessions';

  List<SavedSession> get sessions => _sessions;

  SessionManager() {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sessionsJson = prefs.getString(_sessionsKey);

    if (sessionsJson != null) {
      final List<dynamic> decoded = json.decode(sessionsJson);
      _sessions = decoded.map((item) => SavedSession.fromJson(item)).toList();
      notifyListeners();
      print('✅ Загружено ${_sessions.length} сессий из SharedPreferences');
    }
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_sessionsKey, encoded);
    print('💾 Сохранено ${_sessions.length} сессий в SharedPreferences');
  }

  Future<void> addSession(SavedSession session) async {
    _sessions.add(session);
    await _saveSessions();
    notifyListeners();
    print('✅ Добавлена сессия: ${session.name}');
  }

  Future<void> removeSession(int index) async {
    if (index >= 0 && index < _sessions.length) {
      final removed = _sessions.removeAt(index);
      await _saveSessions();
      notifyListeners();
      print('❌ Удалена сессия: ${removed.name}');
    }
  }

  Future<void> clearAllSessions() async {
    _sessions.clear();
    await _saveSessions();
    notifyListeners();
    print('🗑️ Все сессии удалены');
  }
}