import 'package:flutter/material.dart';
import '../data/database_repository.dart';
import '../models/session_manager.dart';
import '../components/lottie_loading.dart';

class MySessionsPage extends StatefulWidget {
  const MySessionsPage({super.key});

  @override
  State<MySessionsPage> createState() => _MySessionsPageState();
}

class _MySessionsPageState extends State<MySessionsPage> {
  final DatabaseRepository _repository = DatabaseRepository();
  List<SavedSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    final sessions = await _repository.getAllSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
    print('✅ Загружено ${sessions.length} сессий');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sessions'),
        centerTitle: true,
        actions: [
          if (_sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                await _repository.deleteAllSessions();
                await _loadSessions();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All sessions cleared')),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const LottieLoading()  // ← ЗАМЕНЕНО!
          : _sessions.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No sessions yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('Add steps to your session and save it', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: session.reminder ? Colors.green[100] : Colors.grey[200],
                child: Icon(
                  session.reminder ? Icons.notifications_active : Icons.notifications_off,
                  color: session.reminder ? Colors.green : Colors.grey,
                ),
              ),
              title: Text(
                session.name.isNotEmpty ? session.name : 'Anonymous',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Steps: ${session.stepTitles.length} • ${session.totalMinutes} min'),
            ),
          );
        },
      ),
    );
  }
}