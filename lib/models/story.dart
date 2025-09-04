class StoryCard {
  final String id;
  final String emoji;
  final String description;
  final int correctOrder;

  const StoryCard({
    required this.id,
    required this.emoji,
    required this.description,
    required this.correctOrder,
  });
}

class Story {
  final String id;
  final String title;
  final List<StoryCard> cards;
  final String difficulty;

  const Story({
    required this.id,
    required this.title,
    required this.cards,
    required this.difficulty,
  });

  static List<Story> getStories() {
    return [
      Story(
        id: 'morning_routine',
        title: 'Morning Routine',
        difficulty: 'Medium',
        cards: [
          StoryCard(id: '1', emoji: '😴', description: 'Wake up', correctOrder: 0),
          StoryCard(id: '2', emoji: '🪥', description: 'Brush teeth', correctOrder: 1),
          StoryCard(id: '3', emoji: '🥞', description: 'Eat breakfast', correctOrder: 2),
          StoryCard(id: '4', emoji: '🏫', description: 'Go to school', correctOrder: 3),
        ],
      ),
      Story(
        id: 'sandwich',
        title: 'Making a Sandwich',
        difficulty: 'Easy',
        cards: [
          StoryCard(id: '1', emoji: '🍞', description: 'Get bread', correctOrder: 0),
          StoryCard(id: '2', emoji: '🥬', description: 'Add ingredients', correctOrder: 1),
          StoryCard(id: '3', emoji: '🔪', description: 'Cut sandwich', correctOrder: 2),
        ],
      ),
      Story(
        id: 'planting',
        title: 'Planting a Flower',
        difficulty: 'Medium',
        cards: [
          StoryCard(id: '1', emoji: '🕳️', description: 'Dig hole', correctOrder: 0),
          StoryCard(id: '2', emoji: '🌱', description: 'Place seed', correctOrder: 1),
          StoryCard(id: '3', emoji: '💧', description: 'Water seed', correctOrder: 2),
          StoryCard(id: '4', emoji: '🌸', description: 'Flower grows', correctOrder: 3),
        ],
      ),
      Story(
        id: 'shopping',
        title: 'Going Shopping',
        difficulty: 'Hard',
        cards: [
          StoryCard(id: '1', emoji: '📝', description: 'Make list', correctOrder: 0),
          StoryCard(id: '2', emoji: '🏪', description: 'Go to store', correctOrder: 1),
          StoryCard(id: '3', emoji: '🛒', description: 'Get items', correctOrder: 2),
          StoryCard(id: '4', emoji: '💳', description: 'Pay for items', correctOrder: 3),
          StoryCard(id: '5', emoji: '🏠', description: 'Come home', correctOrder: 4),
          StoryCard(id: '6', emoji: '🛍️', description: 'Put away items', correctOrder: 5),
        ],
      ),
      Story(
        id: 'bedtime',
        title: 'Bedtime Routine',
        difficulty: 'Hard',
        cards: [
          StoryCard(id: '1', emoji: '🍽️', description: 'Eat dinner', correctOrder: 0),
          StoryCard(id: '2', emoji: '🛁', description: 'Take bath', correctOrder: 1),
          StoryCard(id: '3', emoji: '🪥', description: 'Brush teeth', correctOrder: 2),
          StoryCard(id: '4', emoji: '📚', description: 'Read story', correctOrder: 3),
          StoryCard(id: '5', emoji: '😴', description: 'Go to sleep', correctOrder: 4),
          StoryCard(id: '6', emoji: '🌙', description: 'Sweet dreams', correctOrder: 5),
        ],
      ),
    ];
  }
}
