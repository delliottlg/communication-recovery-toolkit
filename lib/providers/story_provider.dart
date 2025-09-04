import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';
import '../services/tts_service.dart';

class StoryProvider extends ChangeNotifier {
  final TTSService _ttsService = TTSService();
  List<Story> _stories = [];
  int _currentStoryIndex = 0;
  List<StoryCard> _userSequence = [];
  bool _isCorrect = false;
  bool _showSuccess = false;
  String _userNarration = '';
  List<String> _savedNarrations = [];

  List<Story> get stories => _stories;
  Story get currentStory => _stories.isNotEmpty ? _stories[_currentStoryIndex] : Story.getStories().first;
  List<StoryCard> get userSequence => _userSequence;
  bool get isCorrect => _isCorrect;
  bool get showSuccess => _showSuccess;
  String get userNarration => _userNarration;
  List<String> get savedNarrations => _savedNarrations;

  StoryProvider() {
    _loadStories();
    _loadProgress();
  }

  void _loadStories() {
    _stories = Story.getStories();
    _userSequence = List.from(_stories[_currentStoryIndex].cards)..shuffle();
    notifyListeners();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _currentStoryIndex = prefs.getInt('current_story_index') ?? 0;
    _savedNarrations = prefs.getStringList('saved_narrations') ?? [];
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_story_index', _currentStoryIndex);
    await prefs.setStringList('saved_narrations', _savedNarrations);
  }

  void reorderCards(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final card = _userSequence.removeAt(oldIndex);
    _userSequence.insert(newIndex, card);
    _isCorrect = false;
    _showSuccess = false;
    notifyListeners();
  }

  void checkOrder() {
    _isCorrect = true;
    for (int i = 0; i < _userSequence.length; i++) {
      if (_userSequence[i].correctOrder != i) {
        _isCorrect = false;
        break;
      }
    }
    
    if (_isCorrect) {
      _showSuccess = true;
      _speakStory();
    }
    notifyListeners();
  }

  void _speakStory() {
    final storyText = _userSequence.map((card) => card.description).join(', then ');
    _ttsService.speak('Great job! The story is: $storyText');
  }

  void nextStory() {
    if (_currentStoryIndex < _stories.length - 1) {
      _currentStoryIndex++;
    } else {
      _currentStoryIndex = 0;
    }
    _resetStory();
    _saveProgress();
  }

  void previousStory() {
    if (_currentStoryIndex > 0) {
      _currentStoryIndex--;
    } else {
      _currentStoryIndex = _stories.length - 1;
    }
    _resetStory();
    _saveProgress();
  }

  void _resetStory() {
    _userSequence = List.from(currentStory.cards)..shuffle();
    _isCorrect = false;
    _showSuccess = false;
    _userNarration = '';
    notifyListeners();
  }

  void updateNarration(String text) {
    _userNarration = text;
    notifyListeners();
  }

  void saveNarration() {
    if (_userNarration.isNotEmpty) {
      _savedNarrations.add('${currentStory.title}: $_userNarration');
      _saveProgress();
      _userNarration = '';
      notifyListeners();
    }
  }

  void speakNarration() {
    if (_userNarration.isNotEmpty) {
      _ttsService.speak(_userNarration);
    }
  }
}
