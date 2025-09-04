import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// TODO: Writing Rebuilder Developer - Replace this placeholder with your implementation
// 
// Requirements for Writing Rebuilder:
// - Interactive writing practice with guided tracing
// - Letter, word, and sentence practice modes
// - Handwriting recognition and feedback
// - Progressive difficulty levels
// - Custom word lists and phrases
// - Visual feedback for stroke accuracy
// - Integration with personal vocabulary
// 
// Available resources:
// - Use Provider pattern similar to AACProvider
// - Use AppTheme for consistent styling
// - TTSService for audio feedback
// - AACTile model for vocabulary integration
// 
// Suggested packages (add to pubspec.yaml):
// - custom_painter for drawing canvas
// - path_provider for saving writing samples
// 
// Suggested folder structure:
// - /widgets/writing_canvas.dart
// - /widgets/trace_guide.dart
// - /models/writing_exercise.dart
// - /providers/writing_provider.dart
// - /services/handwriting_service.dart

class WritingRebuilderScreen extends StatelessWidget {
  const WritingRebuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Writing Rebuilder',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: const _PlaceholderContent(
        title: 'Writing Rebuilder',
        description: 'Rebuild writing skills through guided practice and interactive exercises',
        features: [
          '✏️ Interactive writing canvas',
          '🎯 Letter and word tracing',
          '📝 Sentence construction practice',
          '🔤 Custom vocabulary integration',
          '📊 Stroke accuracy feedback',
          '🎨 Multiple difficulty levels',
          '💾 Save writing progress',
        ],
        developerNote: 'Writing Rebuilder Developer: Implement handwriting practice and recognition here',
      ),
    );
  }
}

class _PlaceholderContent extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final String developerNote;

  const _PlaceholderContent({
    required this.title,
    required this.description,
    required this.features,
    required this.developerNote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppTheme.cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.tertiaryColor, AppTheme.successColor],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Coming Soon',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.tertiaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Planned Features:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.split(' ').first,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature.substring(feature.indexOf(' ') + 1),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.tertiaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: AppTheme.tertiaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Developer Note',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.tertiaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  developerNote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}