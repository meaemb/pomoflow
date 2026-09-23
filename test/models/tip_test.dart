import 'package:pomoflow/models/tip.dart';
import 'package:pomoflow/models/tip_step.dart';
import 'package:test/test.dart';

void main() {
  group('Tip', () {
    test('can instantiate', () {
      // Arrange
      late Tip tip;

      // Act
      tip = Tip(
        id: 'pomodoro',
        name: 'Pomodoro Technique',
        description: 'Work 25 min, break 5 min',
        provider: 'PomoFlow',
        rating: 4.9,
        duration: '25 min',
        level: 'Beginner',
        imageUrl: 'assets/tips/pomodoro.jpg',
        steps: [],
      );

      // Assert
      expect(tip, isNotNull);
      expect(tip.id, equals('pomodoro'));
      expect(tip.name, equals('Pomodoro Technique'));
      expect(tip.rating, equals(4.9));
    });

    test('can get rating and duration', () {
      // Arrange
      final tip = Tip(
        id: 'no_phone',
        name: 'No Phone Rule',
        description: 'Keep phone away',
        provider: 'PomoFlow',
        rating: 4.7,
        duration: '25 min',
        level: 'Easy',
        imageUrl: 'assets/tips/nophone.jpg',
        steps: [],
      );

      // Act
      final result = tip.getRatingAndDuration();

      // Assert
      expect(result, equals('⭐ 4.7 • 25 min • Easy'));
    });

    test('can have steps', () {
      // Arrange
      final steps = [
        TipStep(
          title: 'Choose a task',
          description: 'Pick one specific task',
          fullDescription: 'Select one specific task',
          duration: '1-2 min',
          tip: 'Start with important task',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Set timer',
          description: 'Focus only on that task',
          fullDescription: 'Start the timer for 25 minutes',
          duration: '25 min',
          tip: 'Put phone away',
          durationInMinutes: 25,
        ),
      ];

      // Act
      final tip = Tip(
        id: 'pomodoro',
        name: 'Pomodoro',
        description: 'Work 25 min',
        provider: 'PomoFlow',
        rating: 4.9,
        duration: '25 min',
        level: 'Beginner',
        imageUrl: 'assets/tips/pomodoro.jpg',
        steps: steps,
      );

      // Assert
      expect(tip.steps.length, equals(2));
      expect(tip.steps[0].title, equals('Choose a task'));
      expect(tip.steps[1].durationInMinutes, equals(25));
    });

    test('returns correct rating string for different ratings', () {
      // Arrange
      final tip1 = Tip(
        id: '1',
        name: 'Tip 1',
        description: 'Desc',
        provider: 'PomoFlow',
        rating: 5.0,
        duration: '30 min',
        level: 'Expert',
        imageUrl: '',
        steps: [],
      );

      final tip2 = Tip(
        id: '2',
        name: 'Tip 2',
        description: 'Desc',
        provider: 'PomoFlow',
        rating: 3.5,
        duration: '15 min',
        level: 'Intermediate',
        imageUrl: '',
        steps: [],
      );

      // Assert
      expect(tip1.getRatingAndDuration(), equals('⭐ 5.0 • 30 min • Expert'));
      expect(tip2.getRatingAndDuration(), equals('⭐ 3.5 • 15 min • Intermediate'));
    });

  });
}