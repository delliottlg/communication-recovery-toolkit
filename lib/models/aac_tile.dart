class AACTile {
  final String id;
  final String text;
  final String emoji;
  final AACCategory category;
  final String? soundPath;
  
  const AACTile({
    required this.id,
    required this.text,
    required this.emoji,
    required this.category,
    this.soundPath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'emoji': emoji,
    'category': category.name,
    'soundPath': soundPath,
  };

  factory AACTile.fromJson(Map<String, dynamic> json) => AACTile(
    id: json['id'],
    text: json['text'],
    emoji: json['emoji'],
    category: AACCategory.values.byName(json['category']),
    soundPath: json['soundPath'],
  );
}

enum AACCategory {
  basicNeeds,
  feelings,
  actions,
  questions,
  people,
  places,
  food,
  activities,
}

extension AACCategoryExtension on AACCategory {
  String get displayName {
    switch (this) {
      case AACCategory.basicNeeds:
        return 'Basic Needs';
      case AACCategory.feelings:
        return 'Feelings';
      case AACCategory.actions:
        return 'Actions';
      case AACCategory.questions:
        return 'Questions';
      case AACCategory.people:
        return 'People';
      case AACCategory.places:
        return 'Places';
      case AACCategory.food:
        return 'Food';
      case AACCategory.activities:
        return 'Activities';
    }
  }

  String get emoji {
    switch (this) {
      case AACCategory.basicNeeds:
        return '🏠';
      case AACCategory.feelings:
        return '😊';
      case AACCategory.actions:
        return '🏃';
      case AACCategory.questions:
        return '❓';
      case AACCategory.people:
        return '👥';
      case AACCategory.places:
        return '🏪';
      case AACCategory.food:
        return '🍎';
      case AACCategory.activities:
        return '⚽';
    }
  }
}