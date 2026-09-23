import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/user_review.dart';
import '../components/lottie_loading.dart';

class FeedbackSection extends ConsumerStatefulWidget {
  final String tipId;
  const FeedbackSection({super.key, required this.tipId});

  @override
  ConsumerState<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends ConsumerState<FeedbackSection> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 5;
  bool _isSubmitting = false;

  void _submitFeedback() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);
    final feedbackDao = ref.read(feedbackDaoProvider);
    await feedbackDao.addFeedback(
      widget.tipId,
      _commentController.text.trim(),
      _selectedRating,
    );
    _commentController.clear();
    setState(() => _isSubmitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewsStream = ref.watch(feedbackDaoProvider).getFeedbacksForTip(widget.tipId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'User Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Форма для добавления отзыва
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Leave a review:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return IconButton(
                    icon: Icon(
                      starValue <= _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _selectedRating = starValue),
                  );
                }),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Write your review...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Список отзывов
        StreamBuilder<List<UserReview>>(
          stream: reviewsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LottieLoading();  // ← ЗАМЕНЕНО!
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final reviews = snapshot.data ?? [];
            if (reviews.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No reviews yet. Be the first!')),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                review.userEmail.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                review.userEmail,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: List.generate(5, (i) => Icon(
                                i < review.rating ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(review.comment),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(review.createdAt),
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}