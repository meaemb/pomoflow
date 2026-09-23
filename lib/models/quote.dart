class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  // Локальные цитаты (fallback, если нет интернета)
  static List<Quote> _localQuotes = [
    Quote(text: "The secret of getting ahead is getting started.", author: "Mark Twain"),
    Quote(text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson"),
    Quote(text: "Focus on being productive instead of busy.", author: "Tim Ferriss"),
    Quote(text: "You don't have to be extreme, just consistent.", author: "Unknown"),
    Quote(text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney"),
    Quote(text: "Small daily improvements are the key to staggering long-term results.", author: "Unknown"),
    Quote(text: "It's not about having time. It's about making time.", author: "Unknown"),
    Quote(text: "Productivity is never an accident. It is always the result of a commitment to excellence.", author: "Paul J. Meyer"),
    Quote(text: "The best way to predict the future is to create it.", author: "Peter Drucker"),
    Quote(text: "Start where you are. Use what you have. Do what you can.", author: "Arthur Ashe"),
    Quote(text: "Success is the sum of small efforts, repeated day in and day out.", author: "Robert Collier"),
    Quote(text: "Do the hard jobs first. The easy jobs will take care of themselves.", author: "Dale Carnegie"),
  ];

  // Получить локальную цитату (fallback)
  static Quote getLocalQuote() {
    // Используем день месяца + месяц для разнообразия
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return _localQuotes[dayOfYear % _localQuotes.length];
  }
}