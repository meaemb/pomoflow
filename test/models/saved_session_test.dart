import 'package:pomoflow/models/session_manager.dart';
import 'package:test/test.dart';

void main() {
  group('SavedSession', () {
    test('can instantiate', () {
      // Arrange
      late SavedSession session;

      // Act
      session = SavedSession(
        name: 'Morning Focus',
        reminder: true,
        date: '2026-05-12',
        time: '09:00',
        totalMinutes: 50,
        stepTitles: ['Choose a task', 'Set timer', 'Take break'],
      );

      // Assert
      expect(session, isNotNull);
      expect(session.name, equals('Morning Focus'));
      expect(session.reminder, isTrue);
      expect(session.stepTitles.length, equals(3));
    });

    test('can convert to JSON and back', () {
      // Arrange
      final original = SavedSession(
        name: 'Evening Study',
        reminder: false,
        date: '',
        time: '',
        totalMinutes: 30,
        stepTitles: ['Review notes', 'Practice coding'],
      );

      // Act
      final json = original.toJson();
      final restored = SavedSession.fromJson(json);

      // Assert
      expect(restored.name, equals(original.name));
      expect(restored.reminder, equals(original.reminder));
      expect(restored.totalMinutes, equals(original.totalMinutes));
      expect(restored.stepTitles.length, equals(original.stepTitles.length));
    });

    test('can handle empty step titles', () {
      // Arrange & Act
      final session = SavedSession(
        name: 'Empty Session',
        reminder: false,
        date: '',
        time: '',
        totalMinutes: 0,
        stepTitles: [],
      );

      // Assert
      expect(session.stepTitles.isEmpty, isTrue);
      expect(session.totalMinutes, equals(0));
    });
  });
}