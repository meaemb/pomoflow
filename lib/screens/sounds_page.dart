import 'package:flutter/material.dart';
import '../services/background_manager.dart';
import '../components/audio_player_controls.dart';

class SoundItem {
  final String name;
  final String imageUrl;
  final String soundPath;

  SoundItem({
    required this.name,
    required this.imageUrl,
    required this.soundPath,
  });
}

class SoundsPage extends StatefulWidget {
  const SoundsPage({super.key});

  @override
  State<SoundsPage> createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  final BackgroundManager _manager = BackgroundManager();

  final List<SoundItem> _sounds = [
    SoundItem(
      name: 'Rain',
      imageUrl: 'https://images.unsplash.com/photo-1519690889869-e705e59f72e1?w=300',
      soundPath: 'rain.mp3',
    ),
    SoundItem(
      name: 'Forest',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=300',
      soundPath: 'forest.mp3',
    ),
    SoundItem(
      name: 'Ocean',
      imageUrl: 'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=300',
      soundPath: 'ocean.mp3',
    ),
    SoundItem(
      name: 'Coffee Shop',
      imageUrl: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=300',
      soundPath: 'coffee.mp3',
    ),
    SoundItem(
      name: 'Fireplace',
      imageUrl: 'https://images.unsplash.com/photo-1543393470-b2c833b98dce?w=300',
      soundPath: 'fireplace.mp3',
    ),
    SoundItem(
      name: 'Thunderstorm',
      imageUrl: 'https://images.unsplash.com/photo-1605727216801-e27ce1d0cc28?w=300',
      soundPath: 'thunder.mp3',
    ),
    SoundItem(
      name: 'Beach',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300',
      soundPath: 'beach.mp3',
    ),
    SoundItem(
      name: 'Wind',
      imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=300',
      soundPath: 'wind.mp3',
    ),
    SoundItem(
      name: 'Train',
      imageUrl: 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=300',
      soundPath: 'train.mp3',
    ),
  ];

  IconData _getIconForSound(String? currentSound, String soundName, bool isPlaying, bool isPaused) {
    if (currentSound == soundName) {
      if (isPaused) return Icons.play_arrow;
      return Icons.pause;
    }
    return Icons.play_arrow;
  }

  @override
  void initState() {
    super.initState();
    _manager.addListener(_updateUI);
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _manager.removeListener(_updateUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Sounds',
          style: TextStyle(
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
            image: NetworkImage('https://images.unsplash.com/photo-1543443436-bc6deeff2eb5?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8NjR8fHxlbnwwfHx8fHw%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Tap to play/pause, use controls to stop/next',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _sounds.length,
                  itemBuilder: (context, index) {
                    final sound = _sounds[index];
                    final isPlaying = _manager.currentSound == sound.name && !_manager.isSoundPaused;
                    final isPaused = _manager.currentSound == sound.name && _manager.isSoundPaused;

                    return GestureDetector(
                      onTap: () => _manager.playSound(sound.soundPath, sound.name),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  sound.imageUrl,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconForSound(_manager.currentSound, sound.name, isPlaying, isPaused),
                                  color: Colors.black87,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sound.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: (isPlaying || isPaused) ? FontWeight.bold : FontWeight.normal,
                              color: (isPlaying || isPaused) ? Colors.green : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}