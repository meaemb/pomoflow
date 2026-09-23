import 'package:flutter/material.dart';  // ← добавить для TimeOfDay
import 'package:intl/intl.dart';
import 'saved_step.dart';

class Session {
  final String id;
  final String name;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int reminderType;
  final List<SavedStep> steps;

  Session({
    required this.id,
    required this.name,
    required this.selectedDate,
    required this.selectedTime,
    required this.reminderType,
    required this.steps,
  });

  String getFormattedSessionInfo() {
    String result = '';
    if (selectedDate != null) {
      result += DateFormat('yyyy-MM-dd').format(selectedDate!);
    }
    if (selectedTime != null) {
      final hour = selectedTime!.hour.toString().padLeft(2, '0');
      final minute = selectedTime!.minute.toString().padLeft(2, '0');
      result += ' at $hour:$minute';
    }
    return result.isEmpty ? 'No reminder set' : result;
  }

  int get totalFocusMinutes {
    return steps.fold(0, (sum, step) => sum + step.totalMinutes.toInt());
  }

  int get totalSteps => steps.length;
}