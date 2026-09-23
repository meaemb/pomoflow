import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/saved_session_manager.dart';
import '../models/tip_step.dart';
import '../models/saved_step.dart';
import 'step_control.dart';

class StepDetails extends StatefulWidget {
  final TipStep step;
  final String tipName;
  final SavedSessionManager sessionManager;
  final VoidCallback quantityUpdated;

  const StepDetails({
    super.key,
    required this.step,
    required this.tipName,
    required this.sessionManager,
    required this.quantityUpdated,
  });

  @override
  State<StepDetails> createState() => _StepDetailsState();
}

class _StepDetailsState extends State<StepDetails> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(  // ← ОБЕРНУЛИ В SCROLLVIEW, ЧТОБЫ НЕ БЫЛО ОВЕРФЛОУ
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.step.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ ДОБАВЛЕНО: короткое описание (description)
            if (widget.step.description.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.step.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // "Most Liked" тег (оставил как было, но убрал жесткий цвет)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '# Most Liked',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Полное описание (fullDescription)
            Text(
              widget.step.fullDescription,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Длительность
            Row(
              children: [
                const Icon(Icons.timer, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  widget.step.duration,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Совет (Tip)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tip:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.step.tip,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // StepControl (кнопки + и -)
            StepControl(
              addToSession: (number) {
                const uuid = Uuid();
                final savedStep = SavedStep(
                  id: uuid.v4(),
                  title: widget.step.title,
                  description: widget.step.description,
                  durationInMinutes: widget.step.durationInMinutes,
                  quantity: number,
                );
                setState(() {
                  widget.sessionManager.addStep(savedStep);
                  widget.quantityUpdated();
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}