import 'package:flutter/material.dart';
import 'saved_step.dart';

class SavedSessionManager extends ChangeNotifier {
  List<SavedStep> _savedSteps = [];

  List<SavedStep> get savedSteps => _savedSteps;

  int get totalSteps => _savedSteps.length;

  double get totalFocusTime {
    return _savedSteps.fold(0.0, (sum, item) => sum + item.durationInMinutes);
  }

  void addStep(SavedStep step) {
    _savedSteps.add(step);
    notifyListeners();
  }

  void removeStep(String id) {
    _savedSteps.removeWhere((step) => step.id == id);
    notifyListeners();
  }

  SavedStep stepAt(int index) {
    return _savedSteps[index];
  }

  void resetSession() {
    _savedSteps.clear();
    notifyListeners();
  }

  bool get isEmpty => _savedSteps.isEmpty;
}