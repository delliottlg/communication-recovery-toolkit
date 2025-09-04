import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// TODO: Conversation Starter Developer - Replace this placeholder with your implementation
// 
// Requirements for Conversation Starter:
// - Pre-built conversation templates and scenarios
// - Topic suggestion cards with swipe interaction
// - Social situation practice scenarios
// - Conversation flow guidance
// - Integration with AAC tiles for responses
// - Role-playing scenarios with prompts
// - Difficulty levels for social skills
// 
// Available resources:
// - Use Provider pattern similar to AACProvider
// - Use AppTheme for consistent styling
// - TTSService for audio prompts and responses
// - AACTile model for conversation building
// - CommunicationMessage for saving conversations
// 
// Suggested packages (add to pubspec.yaml):
// - animations: ^2.0.8 (for card swiping)
// 
// Suggested folder structure:
// - /widgets/topic_card.dart
// - /widgets/conversation_flow.dart
// - /models/conversation_scenario.dart
// - /providers/conversation_provider.dart
// - /services/conversation_service.dart

class ConversationStarterScreen extends StatelessWidget {
  const ConversationStarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Conversation Starter',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: const _PlaceholderContent(
        title: 'Conversation Starter',
        description: 'Practice social conversations with guided scenarios and topic suggestions',
        features: [
          '💬 Pre-built conversation templates',
          '🎭 Role-playing social scenarios',
          '🃏 Swipeable topic suggestion cards',
          '🗣️ Conversation flow guidance',
          '🤝 Social skills practice levels',
          '🔗 AAC tile integration',
          '📚 Custom scenario creation',
        ],
        developerNote: 'Conversation Starter Developer: Implement social conversation practice here',
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
                          colors: [AppTheme.infoColor, AppTheme.primaryColor],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.chat_bubble,
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
                              color: AppTheme.infoColor,
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
              color: AppTheme.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.infoColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: AppTheme.infoColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Developer Note',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.infoColor,
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