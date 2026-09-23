import 'package:flutter/material.dart';

enum ColorSelection {
  deepPurple('Deep Purple', Colors.deepPurple),
  purple('Purple', Colors.purple),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSelection(this.label, this.color);
  final String label;
  final Color color;
}

enum PomoTab {
  explore,
  sessions,
  account,
}

extension PomoTabExtension on PomoTab {
  int get value {
    switch (this) {
      case PomoTab.explore:
        return 0;
      case PomoTab.sessions:
        return 1;
      case PomoTab.account:
        return 2;
    }
  }

  static PomoTab fromValue(int value) {
    switch (value) {
      case 0:
        return PomoTab.explore;
      case 1:
        return PomoTab.sessions;
      default:
        return PomoTab.account;
    }
  }
}