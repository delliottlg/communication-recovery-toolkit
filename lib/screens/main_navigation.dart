import 'package:flutter/material.dart';
import 'aac_board_screen.dart';
import 'story_sequencer_screen.dart';
import 'progress_tracker_screen.dart';
import 'writing_rebuilder_screen.dart';
import 'conversation_starter_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    AACBoardScreen(),
    StorySequencerScreen(),
    ProgressTrackerScreen(),
    WritingRebuilderScreen(),
    ConversationStarterScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.grid_view_rounded),
      activeIcon: Icon(Icons.grid_view_rounded),
      label: 'AAC Board',
      tooltip: 'Communication Board',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.auto_stories_outlined),
      activeIcon: Icon(Icons.auto_stories),
      label: 'Stories',
      tooltip: 'Story Sequencer',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.trending_up_outlined),
      activeIcon: Icon(Icons.trending_up),
      label: 'Progress',
      tooltip: 'Progress Tracker',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_outlined),
      activeIcon: Icon(Icons.edit),
      label: 'Writing',
      tooltip: 'Writing Rebuilder',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      activeIcon: Icon(Icons.chat_bubble),
      label: 'Chat',
      tooltip: 'Conversation Starter',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 8,
      ),
    );
  }
}