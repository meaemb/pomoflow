import 'package:cloud_firestore/cloud_firestore.dart';

class UserReview {
  final String id;
  final String tipId;
  final String userId;
  final String userEmail;
  final String comment;
  final int rating; // 1-5
  final DateTime createdAt;

  UserReview({
    required this.id,
    required this.tipId,
    required this.userId,
    required this.userEmail,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'tipId': tipId,
    'userId': userId,
    'userEmail': userEmail,
    'comment': comment,
    'rating': rating,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory UserReview.fromJson(Map<String, dynamic> json, String docId) => UserReview(
    id: docId,
    tipId: json['tipId'],
    userId: json['userId'],
    userEmail: json['userEmail'],
    comment: json['comment'],
    rating: json['rating'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
  );
}