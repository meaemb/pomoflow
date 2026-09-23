import 'package:pomoflow/data/database_repository.dart';
import 'package:pomoflow/models/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('DatabaseRepository', () {
    late DatabaseRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = DatabaseRepository();
    });

    test('can instantiate', () {
      // Assert
      expect(repository, isNotNull);
    });

    test('can create and retrieve session', () async {
      // Arrange
      const sessionName = 'Test Session';
      const stepTitles = ['Step 1', 'Step 2'];

      // Act
      await repository.createSession(
        name: sessionName,
        reminder: true,
        date: '2026-05-12',
        time: '10:00',
        totalMinutes: 45,
        stepTitles: stepTitles,
      );

      final sessions = await repository.getAllSessions();

      // Assert
      expect(sessions.length, equals(1));
      expect(sessions[0].name, equals(sessionName));
      expect(sessions[0].stepTitles.length, equals(2));
    });

    test('can create multiple sessions', () async {
      // Arrange
      await repository.createSession(
        name: 'Session 1',
        reminder: false,
        date: '',
        time: '',
        totalMinutes: 25,
        stepTitles: ['Step A'],
      );

      await repository.createSession(
        name: 'Session 2',
        reminder: true,
        date: '2026-05-13',
        time: '14:00',
        totalMinutes: 30,
        stepTitles: ['Step B', 'Step C'],
      );

      // Act
      final sessions = await repository.getAllSessions();

      // Assert
      expect(sessions.length, equals(2));
      expect(sessions[0].name, equals('Session 1'));
      expect(sessions[1].name, equals('Session 2'));
    });

    test('can delete all sessions', () async {
      // Arrange
      await repository.createSession(
        name: 'To Delete',
        reminder: false,
        date: '',
        time: '',
        totalMinutes: 10,
        stepTitles: ['Step'],
      );

      // Act
      await repository.deleteAllSessions();
      final sessions = await repository.getAllSessions();

      // Assert
      expect(sessions.isEmpty, isTrue);
    });

    test('returns empty list when no sessions', () async {
      // Act
      final sessions = await repository.getAllSessions();

      // Assert
      expect(sessions, isEmpty);
    });
  });
}