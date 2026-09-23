import 'package:flutter/material.dart';
import '../services/background_manager.dart';

class AudioPlayerControls extends StatefulWidget {
  final BackgroundManager manager;

  const AudioPlayerControls({super.key, required this.manager});

  @override
  State<AudioPlayerControls> createState() => _AudioPlayerControlsState();
}

class _AudioPlayerControlsState extends State<AudioPlayerControls> {
  @override
  void initState() {
    super.initState();
    // ПОДПИСЫВАЕМСЯ на изменения
    widget.manager.addListener(_updateUI);
  }

  void _updateUI() {
    if (mounted) {
      setState(() {}); // ПЕРЕСТРАИВАЕМ ВИДЖЕТ
    }
  }

  @override
  void dispose() {
    // ОТПИСЫВАЕМСЯ
    widget.manager.removeListener(_updateUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = widget.manager;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Иконка звука
          Icon(
            manager.isSoundPlaying ? Icons.volume_up : Icons.volume_off,
            size: 20,
            color: Colors.white70,
          ),
          const SizedBox(width: 8),

          if (manager.isSoundPlaying) ...[
            // Название текущего звука
            Container(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                manager.currentSound!.length > 10
                    ? '${manager.currentSound!.substring(0, 10)}...'
                    : manager.currentSound!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),

            // Кнопка Stop (серая)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.stop, size: 18),
                onPressed: () async {
                  await manager.stopSound();
                },
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                color: Colors.white,
                tooltip: 'Stop',
              ),
            ),
            const SizedBox(width: 4),

            // Кнопка Next (серая)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.skip_next, size: 18),
                onPressed: () async {
                  await manager.playNextSound();
                },
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                color: Colors.white,
                tooltip: 'Next sound',
              ),
            ),
          ],

          if (!manager.isSoundPlaying)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.play_arrow, size: 18),
                onPressed: () async {
                  await manager.playSoundByIndex(0);
                },
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                color: Colors.white,
                tooltip: 'Play music',
              ),
            ),
        ],
      ),
    );
  }
}