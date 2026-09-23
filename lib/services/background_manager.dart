import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class BackgroundManager {
  static final BackgroundManager _instance = BackgroundManager._internal();
  factory BackgroundManager() => _instance;
  BackgroundManager._internal();

  Timer? _timer;
  int _secondsLeft = 25 * 60;
  bool _isRunning = false;
  bool _isWorkSession = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _alarmPlayer = AudioPlayer();
  String? _currentSound;
  int _currentSoundIndex = -1;
  bool _isSoundPaused = false;
  List<void Function()> _listeners = [];

  static const int workDuration = 25 * 60;
  static const int breakDuration = 5 * 60;

  final List<Map<String, String>> _soundLibrary = [
    {'name': 'Rain', 'path': 'rain.mp3'},
    {'name': 'Forest', 'path': 'forest.mp3'},
    {'name': 'Ocean', 'path': 'ocean.mp3'},
    {'name': 'Coffee Shop', 'path': 'coffee.mp3'},
    {'name': 'Fireplace', 'path': 'fireplace.mp3'},
    {'name': 'Thunderstorm', 'path': 'thunder.mp3'},
    {'name': 'Beach', 'path': 'beach.mp3'},
    {'name': 'Wind', 'path': 'wind.mp3'},
    {'name': 'Train', 'path': 'train.mp3'},
  ];

  int get secondsLeft => _secondsLeft;
  bool get isRunning => _isRunning;
  bool get isWorkSession => _isWorkSession;
  String? get currentSound => _currentSound;
  bool get isSoundPlaying => _currentSound != null && !_isSoundPaused;
  bool get isSoundPaused => _isSoundPaused;

  String get formattedTime {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get sessionType => _isWorkSession ? 'Focus Time' : 'Break Time';

  // Управление звуками
  Future<void> playSoundByIndex(int index) async {
    if (index < 0 || index >= _soundLibrary.length) return;

    final sound = _soundLibrary[index];
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/${sound['path']}'));
    _currentSound = sound['name'];
    _currentSoundIndex = index;
    _isSoundPaused = false;
    _notifyListeners();
  }

  Future<void> playNextSound() async {
    if (_soundLibrary.isEmpty) return;
    final nextIndex = (_currentSoundIndex + 1) % _soundLibrary.length;
    await playSoundByIndex(nextIndex);
  }

  Future<void> pauseSound() async {
    await _audioPlayer.pause();
    _isSoundPaused = true;
    _notifyListeners();
  }

  Future<void> resumeSound() async {
    await _audioPlayer.resume();
    _isSoundPaused = false;
    _notifyListeners();
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
    _currentSound = null;
    _currentSoundIndex = -1;
    _isSoundPaused = false;
    _notifyListeners();
  }

  Future<void> playSound(String soundPath, String soundName) async {
    // Если этот же звук уже играет, ставим на паузу
    if (_currentSound == soundName && !_isSoundPaused) {
      await pauseSound();
    }
    // Если этот же звук на паузе, возобновляем
    else if (_currentSound == soundName && _isSoundPaused) {
      await resumeSound();
    }
    // Иначе включаем новый звук
    else {
      final index = _soundLibrary.indexWhere((s) => s['name'] == soundName);
      if (index != -1) {
        await playSoundByIndex(index);
      }
    }
  }

  // Таймер
  void startTimer() {
    if (_secondsLeft == 0) {
      _switchSession();
    }
    if (_isRunning) return;
    _isRunning = true;
    _notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        _secondsLeft--;
        _notifyListeners();
      } else {
        _switchSession();
      }
    });
  }

  void _playAlarm() async {
    _notifyListeners();
  }

  void _switchSession() {
    _timer?.cancel();
    _isRunning = false;

    _playAlarm();

    if (_isWorkSession) {
      _isWorkSession = false;
      _secondsLeft = breakDuration;
    } else {
      _isWorkSession = true;
      _secondsLeft = workDuration;
    }

    _notifyListeners();
    startTimer();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    _notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _isWorkSession = true;
    _secondsLeft = workDuration;
    _notifyListeners();
  }

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _alarmPlayer.dispose();
  }
}