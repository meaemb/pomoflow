import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/tip.dart';

class SavedTipsPage extends ConsumerStatefulWidget {
  const SavedTipsPage({super.key});

  @override
  ConsumerState<SavedTipsPage> createState() => _SavedTipsPageState();
}

class _SavedTipsPageState extends ConsumerState<SavedTipsPage> {
  @override
  Widget build(BuildContext context) {
    final tipState = ref.watch(tipProvider);
    final savedTips = tipState.savedTips;
    final notifier = ref.read(tipProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Tips'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          // Кнопка "Remove All" (опционально)
          if (savedTips.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Remove all saved tips',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remove all saved tips?'),
                    content: const Text('This will remove all tips from your saved list.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          for (final tip in savedTips) {
                            notifier.toggleSavedTip(tip.id);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Remove All', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: savedTips.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No saved tips yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on any tip to save it',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: savedTips.length,
        itemBuilder: (context, index) {
          final tip = savedTips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Dismissible(
              // Для свайпа влево/вправо для удаления
              key: Key(tip.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                notifier.toggleSavedTip(tip.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "${tip.name}" from saved tips'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.lightbulb_outline, color: Colors.amber),
                ),
                title: Text(
                  tip.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  tip.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    // Удаляем из избранного при нажатии на сердечко
                    notifier.toggleSavedTip(tip.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed "${tip.name}" from saved tips'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: 'Remove from saved',
                ),
                onTap: () {
                  // Можно добавить навигацию на детали совета
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TipDetailPage(tip: tip),
                  //   ),
                  // );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}