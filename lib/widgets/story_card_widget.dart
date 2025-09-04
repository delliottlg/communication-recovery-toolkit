import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';

class StoryCardWidget extends StatelessWidget {
  final StoryCard card;
  final bool isCorrectPosition;
  final bool showFeedback;

  const StoryCardWidget({
    super.key,
    required this.card,
    this.isCorrectPosition = false,
    this.showFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: showFeedback
            ? (isCorrectPosition ? Colors.green.shade100 : Colors.red.shade100)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showFeedback
              ? (isCorrectPosition ? Colors.green : Colors.red)
              : AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              card.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
