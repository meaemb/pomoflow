import 'package:pomoflow/models/user_review.dart';
import 'package:test/test.dart';

void main() {
  group('UserReview', () {
    final now = DateTime.now();

    test('can instantiate', () {
      // Arrange & Act
      final review = UserReview(
        id: 'review_123',
        tipId: 'pomodoro',
        userId: 'user_456',
        userEmail: 'test@example.com',
        comment: 'Great tip! Helped me a lot.',
        rating: 5,
        createdAt: now,
      );

      // Assert
      expect(review, isNotNull);
      expect(review.id, equals('review_123'));
      expect(review.tipId, equals('pomodoro'));
      expect(review.userEmail, equals('test@example.com'));
      expect(review.comment, equals('Great tip! Helped me a lot.'));
      expect(review.rating, equals(5));
      expect(review.createdAt, equals(now));
    });

    test('can convert to JSON and back', () {
      // Arrange
      final original = UserReview(
        id: 'review_123',
        tipId: 'pomodoro',
        userId: 'user_456',
        userEmail: 'test@example.com',
        comment: 'Awesome!',
        rating: 4,
        createdAt: now,
      );

      // Act
      final json = original.toJson();

      // Assert
      expect(json['tipId'], equals('pomodoro'));
      expect(json['userId'], equals('user_456'));
      expect(json['userEmail'], equals('test@example.com'));
      expect(json['comment'], equals('Awesome!'));
      expect(json['rating'], equals(4));
      expect(json['createdAt'], isNotNull);
    });

    test('can have rating from 1 to 5', () {
      // Arrange & Assert
      final review1 = UserReview(
        id: '1', tipId: 't1', userId: 'u1', userEmail: 'e1',
        comment: 'Bad', rating: 1, createdAt: now,
      );
      final review5 = UserReview(
        id: '5', tipId: 't2', userId: 'u2', userEmail: 'e2',
        comment: 'Excellent', rating: 5, createdAt: now,
      );

      expect(review1.rating, equals(1));
      expect(review5.rating, equals(5));
    });
  });
}