import 'package:flutter/material.dart';
import '../models/review.dart';
import 'review_card.dart';

class ReviewSection extends StatelessWidget {
  final List<Review> reviews;

  const ReviewSection({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'User Reviews',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewCard(review: reviews[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
          ),
        ],
      ),
    );
  }
}