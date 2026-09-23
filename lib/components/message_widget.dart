import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers.dart';
import 'message.dart';

class MessageWidget extends ConsumerWidget {
  const MessageWidget(this.message, {super.key});
  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userDao = ref.watch(userDaoProvider);
    final myMessage = message.email == userDao.email();
    return FractionallySizedBox(
      alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: myMessage ? Colors.green[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.text, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!myMessage) Text(message.email, style: TextStyle(color: theme.colorScheme.secondary)),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat.yMd().format(message.date)} ${DateFormat.Hm().format(message.date)}',
                  style: TextStyle(color: theme.colorScheme.secondary, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}