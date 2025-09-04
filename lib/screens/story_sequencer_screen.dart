import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/story_provider.dart';
import '../widgets/story_card_widget.dart';

class StorySequencerScreen extends StatelessWidget {
  const StorySequencerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryProvider(),
      child: const _StorySequencerContent(),
    );
  }
}

class _StorySequencerContent extends StatelessWidget {
  const _StorySequencerContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Story Sequencer'),
        actions: [
          Consumer<StoryProvider>(
            builder: (context, provider, _) => PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'narrations') {
                  _showNarrationsDialog(context, provider);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'narrations',
                  child: Row(
                    children: [
                      Icon(Icons.history),
                      SizedBox(width: 8),
                      Text('Saved Narrations'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, _) => Column(
          children: [
            _StoryHeader(provider: provider),
            Expanded(
              child: _StorySequenceArea(provider: provider),
            ),
            _ControlButtons(provider: provider),
            if (provider.isCorrect) _NarrationSection(provider: provider),
          ],
        ),
      ),
    );
  }

  void _showNarrationsDialog(BuildContext context, StoryProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Saved Narrations'),
        content: SizedBox(
          width: double.maxFinite,
          child: provider.savedNarrations.isEmpty
              ? const Text('No narrations saved yet.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.savedNarrations.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(provider.savedNarrations[index]),
                    dense: true,
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  final StoryProvider provider;

  const _StoryHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.currentStory.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Difficulty: ${provider.currentStory.difficulty}',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: provider.previousStory,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: provider.nextStory,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StorySequenceArea extends StatelessWidget {
  final StoryProvider provider;

  const _StorySequenceArea({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.userSequence.length,
        onReorder: provider.reorderCards,
        itemBuilder: (context, index) {
          final card = provider.userSequence[index];
          final isCorrect = provider.isCorrect && card.correctOrder == index;
          
          return SizedBox(
            key: ValueKey(card.id),
            width: 120,
            child: StoryCardWidget(
              card: card,
              isCorrectPosition: isCorrect,
              showFeedback: provider.isCorrect,
            ),
          );
        },
      ),
    );
  }
}

class _ControlButtons extends StatelessWidget {
  final StoryProvider provider;

  const _ControlButtons({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: provider.checkOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Check Order'),
            ),
          ),
          if (provider.showSuccess) ...[
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Correct!', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NarrationSection extends StatefulWidget {
  final StoryProvider provider;

  const _NarrationSection({required this.provider});

  @override
  State<_NarrationSection> createState() => _NarrationSectionState();
}

class _NarrationSectionState extends State<_NarrationSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Great! Now tell the story in your own words:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            onChanged: widget.provider.updateNarration,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe what happens in this story...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: widget.provider.speakNarration,
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  widget.provider.saveNarration();
                  _controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Narration saved!')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}