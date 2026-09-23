import 'package:flutter/material.dart';
import '../models/tip.dart';
import '../models/saved_session_manager.dart';
import '../models/session_manager.dart';
import 'tip_card.dart';

class TipSection extends StatelessWidget {
  final List<Tip> tips;
  final void Function(Tip) onToggleSave;
  final bool Function(Tip) isSaved;
  final SavedSessionManager sessionManager;
  final SessionManager sessionManagerOrders;

  const TipSection({
    super.key,
    required this.tips,
    required this.onToggleSave,
    required this.isSaved,
    required this.sessionManager,
    required this.sessionManagerOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'Popular Pomodoro Tips',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];
                return SizedBox(
                  width: 280,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TipCard(
                      tip: tip,
                      index: index,
                      isSaved: isSaved(tip),
                      onToggleSave: () => onToggleSave(tip),
                      sessionManager: sessionManager,
                      sessionManagerOrders: sessionManagerOrders,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}