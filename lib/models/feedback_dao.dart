import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_review.dart';
import 'user_dao.dart';

class FeedbackDao {
  final UserDao userDao;
  final CollectionReference collection = FirebaseFirestore.instance.collection('feedbacks');

  FeedbackDao(this.userDao);

  Future<void> addFeedback(String tipId, String comment, int rating) async {
    final review = UserReview(
      id: '',
      tipId: tipId,
      userId: userDao.userId()!,
      userEmail: userDao.email()!,
      comment: comment,
      rating: rating,
      createdAt: DateTime.now(),
    );
    await collection.add(review.toJson());
  }

  Stream<List<UserReview>> getFeedbacksForTip(String tipId) {
    return collection
        .where('tipId', isEqualTo: tipId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserReview.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<double> getAverageRating(String tipId) async {
    final snapshot = await collection.where('tipId', isEqualTo: tipId).get();
    if (snapshot.docs.isEmpty) return 0;
    final total = snapshot.docs.fold<int>(0, (sum, doc) => sum + (doc['rating'] as int));
    return total / snapshot.docs.length;
  }

  Future<void> deleteFeedback(String feedbackId) async {
    await collection.doc(feedbackId).delete();
  }
}