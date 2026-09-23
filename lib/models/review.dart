class Review {
  final String comment;
  final int timestamp;  // дней назад
  final String userAvatar;

  Review({
    required this.comment,
    required this.timestamp,
    required this.userAvatar,
  });

  static List<Review> samples = [
    Review(
      comment: 'Pomodoro helped me pass my exam! I did 8 cycles today!',
      timestamp: 3,
      userAvatar: 'https://randomuser.me/api/portraits/women/1.jpg',
    ),
    Review(
      comment: 'The timer keeps me focused on one task at a time',
      timestamp: 7,
      userAvatar: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
    Review(
      comment: 'Best productivity app I have ever used! 🔥',
      timestamp: 1,
      userAvatar: 'https://randomuser.me/api/portraits/women/3.jpg',
    ),
    Review(
      comment: 'My focus has improved dramatically since using this app.',
      timestamp: 14,
      userAvatar: 'https://randomuser.me/api/portraits/men/4.jpg',
    ),
    Review(
      comment: 'Love the sound options! Rain sounds help me concentrate.',
      timestamp: 5,
      userAvatar: 'https://randomuser.me/api/portraits/women/5.jpg',
    ),
    Review(
      comment: 'Finally an app that actually works for ADHD brain!',
      timestamp: 2,
      userAvatar: 'https://randomuser.me/api/portraits/men/6.jpg',
    ),
    Review(
      comment: 'The sessions feature is a game-changer for planning my day.',
      timestamp: 10,
      userAvatar: 'https://randomuser.me/api/portraits/women/7.jpg',
    ),
    Review(
      comment: 'I recommended this to all my coworkers. Highly recommend! ⭐⭐⭐⭐⭐',
      timestamp: 21,
      userAvatar: 'https://randomuser.me/api/portraits/men/8.jpg',
    ),
    Review(
      comment: 'The UI is beautiful and very intuitive.',
      timestamp: 4,
      userAvatar: 'https://randomuser.me/api/portraits/women/9.jpg',
    ),
    Review(
      comment: 'Helped me finish my thesis on time! Thank you PomoFlow!',
      timestamp: 30,
      userAvatar: 'https://randomuser.me/api/portraits/men/10.jpg',
    ),
    Review(
      comment: 'Love the motivational quotes every day 💪',
      timestamp: 6,
      userAvatar: 'https://randomuser.me/api/portraits/women/11.jpg',
    ),
    Review(
      comment: 'The best Pomodoro app on the market. Period.',
      timestamp: 12,
      userAvatar: 'https://randomuser.me/api/portraits/men/12.jpg',
    ),
  ];
}