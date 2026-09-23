class Category {
  final String name;
  final int count;
  final String imageUrl;

  Category({
    required this.name,
    required this.count,
    required this.imageUrl,
  });

  static List<Category> samples = [
    Category(name: 'Work', count: 12, imageUrl: 'https://cdn-icons-png.flaticon.com/128/5578/5578703.png'),
    Category(name: 'Study', count: 10, imageUrl: 'https://cdn-icons-png.flaticon.com/128/747/747086.png'),
    Category(name: 'Coding', count: 8, imageUrl: 'https://cdn-icons-png.flaticon.com/128/2115/2115955.png'),
    Category(name: 'Creative', count: 6, imageUrl: 'https://cdn-icons-png.flaticon.com/128/7133/7133613.png'),
  ];
}