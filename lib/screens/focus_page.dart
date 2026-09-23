import 'dart:async';
import 'package:flutter/material.dart';
import '../services/background_manager.dart';
import '../components/audio_player_controls.dart';
import '../components/scale_button.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> with SingleTickerProviderStateMixin {
  final BackgroundManager _manager = BackgroundManager();
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _manager.addListener(_updateUI);

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    _colorController.value = 1.0;
  }

  void _updateUI() {
    if (mounted) {
      final int totalSeconds = _manager.isWorkSession
          ? BackgroundManager.workDuration
          : BackgroundManager.breakDuration;
      final remaining = _manager.secondsLeft;
      final progress = remaining / totalSeconds;

      setState(() {});

      _colorController.animateTo(
        progress,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  void dispose() {
    _manager.removeListener(_updateUI);
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalSeconds = _manager.isWorkSession
        ? BackgroundManager.workDuration
        : BackgroundManager.breakDuration;
    final remaining = _manager.secondsLeft;
    final progress = remaining / totalSeconds;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _manager.sessionType,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          AudioPlayerControls(manager: _manager),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                width: 280,
                height: 280,
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CircularTimerPainter(
                        progress: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        activeColor: _colorAnimation.value ?? Colors.red,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _manager.formattedTime,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'monospace',
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _manager.isWorkSession ? 'Focus' : 'Break',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_manager.isRunning && _manager.secondsLeft > 0)
                    ScaleButton(
                      onPressed: () {
                        _manager.startTimer();
                        _colorController.value = 1.0;
                      },
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('START'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  if (_manager.isRunning)
                    ScaleButton(
                      onPressed: _manager.pauseTimer,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.pause),
                        label: const Text('PAUSE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  ScaleButton(
                    onPressed: () {
                      _manager.resetTimer();
                      _colorController.value = 1.0;
                    },
                    child: OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.refresh),
                      label: const Text('RESET'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color activeColor;

  CircularTimerPainter({
    required this.progress,
    required this.backgroundColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final paint = Paint()
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    paint.color = backgroundColor;
    canvas.drawCircle(center, radius, paint);

    paint.color = activeColor;
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.activeColor != activeColor;
  }
}