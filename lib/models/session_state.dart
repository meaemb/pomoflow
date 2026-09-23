import 'package:flutter_riverpod/flutter_riverpod.dart';

// Состояние сессии (таймера)
class SessionState {
  final int secondsLeft;
  final bool isRunning;
  final bool isWorkSession;
  final String currentSound;

  SessionState({
    required this.secondsLeft,
    required this.isRunning,
    required this.isWorkSession,
    required this.currentSound,
  });

  factory SessionState.initial() {
    return SessionState(
      secondsLeft: 25 * 60,
      isRunning: false,
      isWorkSession: true,
      currentSound: '',
    );
  }

  String get formattedTime {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get sessionType => isWorkSession ? 'Focus Time' : 'Break Time';

  SessionState copyWith({
    int? secondsLeft,
    bool? isRunning,
    bool? isWorkSession,
    String? currentSound,
  }) {
    return SessionState(
      secondsLeft: secondsLeft ?? this.secondsLeft,
      isRunning: isRunning ?? this.isRunning,
      isWorkSession: isWorkSession ?? this.isWorkSession,
      currentSound: currentSound ?? this.currentSound,
    );
  }
}

// Notifier для управления сессией
class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(SessionState.initial());

  void startTimer() {
    state = state.copyWith(isRunning: true);
  }

  void pauseTimer() {
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    state = state.copyWith(
      secondsLeft: 25 * 60,
      isRunning: false,
      isWorkSession: true,
    );
  }

  void updateSeconds(int seconds) {
    state = state.copyWith(secondsLeft: seconds);
  }

  void switchSession() {
    final newIsWorkSession = !state.isWorkSession;
    final newSeconds = newIsWorkSession ? 25 * 60 : 5 * 60;
    state = state.copyWith(
      isWorkSession: newIsWorkSession,
      secondsLeft: newSeconds,
      isRunning: false,
    );
  }

  void setSound(String soundName) {
    state = state.copyWith(currentSound: soundName);
  }

  void stopSound() {
    state = state.copyWith(currentSound: '');
  }
}

// Провайдер для сессии
final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});