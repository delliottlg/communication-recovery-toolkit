import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/aac_tile.dart';
import '../models/communication_message.dart';
import '../services/tts_service.dart';

class AACProvider extends ChangeNotifier {
  final TTSService _ttsService = TTSService();
  
  List<AACTile> _tiles = [];
  List<AACTile> _selectedTiles = [];
  AACCategory? _selectedCategory;
  double _tileSize = 1.0;
  bool _isLoading = false;

  List<AACTile> get tiles => _selectedCategory == null 
      ? _tiles 
      : _tiles.where((tile) => tile.category == _selectedCategory).toList();
  
  List<AACTile> get selectedTiles => _selectedTiles;
  AACCategory? get selectedCategory => _selectedCategory;
  double get tileSize => _tileSize;
  bool get isLoading => _isLoading;
  
  String get currentMessage => _selectedTiles.map((tile) => tile.text).join(' ');
  bool get hasMessage => _selectedTiles.isNotEmpty;

  AACProvider() {
    _initializeTiles();
    _loadPreferences();
    _ttsService.initialize();
  }

  void _initializeTiles() {
    _tiles = [
      // Basic Needs
      const AACTile(id: '1', text: 'I want', emoji: '👋', category: AACCategory.basicNeeds),
      const AACTile(id: '2', text: 'I need', emoji: '🙏', category: AACCategory.basicNeeds),
      const AACTile(id: '3', text: 'help', emoji: '🆘', category: AACCategory.basicNeeds),
      const AACTile(id: '4', text: 'water', emoji: '💧', category: AACCategory.basicNeeds),
      const AACTile(id: '5', text: 'food', emoji: '🍎', category: AACCategory.basicNeeds),
      const AACTile(id: '6', text: 'bathroom', emoji: '🚻', category: AACCategory.basicNeeds),
      const AACTile(id: '7', text: 'please', emoji: '🙏', category: AACCategory.basicNeeds),
      const AACTile(id: '8', text: 'thank you', emoji: '🙏', category: AACCategory.basicNeeds),
      
      // Feelings
      const AACTile(id: '9', text: 'happy', emoji: '😊', category: AACCategory.feelings),
      const AACTile(id: '10', text: 'sad', emoji: '😢', category: AACCategory.feelings),
      const AACTile(id: '11', text: 'angry', emoji: '😠', category: AACCategory.feelings),
      const AACTile(id: '12', text: 'scared', emoji: '😨', category: AACCategory.feelings),
      const AACTile(id: '13', text: 'excited', emoji: '🤩', category: AACCategory.feelings),
      const AACTile(id: '14', text: 'tired', emoji: '😴', category: AACCategory.feelings),
      const AACTile(id: '15', text: 'confused', emoji: '😕', category: AACCategory.feelings),
      const AACTile(id: '16', text: 'proud', emoji: '😤', category: AACCategory.feelings),
      
      // Actions
      const AACTile(id: '17', text: 'go', emoji: '🚶', category: AACCategory.actions),
      const AACTile(id: '18', text: 'stop', emoji: '✋', category: AACCategory.actions),
      const AACTile(id: '19', text: 'play', emoji: '🎮', category: AACCategory.actions),
      const AACTile(id: '20', text: 'eat', emoji: '🍽️', category: AACCategory.actions),
      const AACTile(id: '21', text: 'drink', emoji: '🥤', category: AACCategory.actions),
      const AACTile(id: '22', text: 'sleep', emoji: '😴', category: AACCategory.actions),
      const AACTile(id: '23', text: 'read', emoji: '📚', category: AACCategory.actions),
      const AACTile(id: '24', text: 'write', emoji: '✍️', category: AACCategory.actions),
      
      // Questions
      const AACTile(id: '25', text: 'what', emoji: '❓', category: AACCategory.questions),
      const AACTile(id: '26', text: 'where', emoji: '📍', category: AACCategory.questions),
      const AACTile(id: '27', text: 'when', emoji: '⏰', category: AACCategory.questions),
      const AACTile(id: '28', text: 'who', emoji: '👤', category: AACCategory.questions),
      const AACTile(id: '29', text: 'why', emoji: '🤔', category: AACCategory.questions),
      const AACTile(id: '30', text: 'how', emoji: '❓', category: AACCategory.questions),
      
      // People
      const AACTile(id: '31', text: 'mom', emoji: '👩', category: AACCategory.people),
      const AACTile(id: '32', text: 'dad', emoji: '👨', category: AACCategory.people),
      const AACTile(id: '33', text: 'friend', emoji: '👫', category: AACCategory.people),
      const AACTile(id: '34', text: 'teacher', emoji: '👩‍🏫', category: AACCategory.people),
      
      // Additional tiles for more variety
      const AACTile(id: '35', text: 'yes', emoji: '✅', category: AACCategory.basicNeeds),
      const AACTile(id: '36', text: 'no', emoji: '❌', category: AACCategory.basicNeeds),
      const AACTile(id: '37', text: 'more', emoji: '➕', category: AACCategory.basicNeeds),
      const AACTile(id: '38', text: 'finished', emoji: '✅', category: AACCategory.basicNeeds),
    ];
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _tileSize = prefs.getDouble('tileSize') ?? 1.0;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error loading preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('tileSize', _tileSize);
    } catch (e) {
      if (kDebugMode) print('Error saving preferences: $e');
    }
  }

  void selectTile(AACTile tile) {
    _selectedTiles.add(tile);
    notifyListeners();
    _speak(tile.text);
  }

  void clearMessage() {
    _selectedTiles.clear();
    notifyListeners();
  }

  void removeLastTile() {
    if (_selectedTiles.isNotEmpty) {
      _selectedTiles.removeLast();
      notifyListeners();
    }
  }

  void speakMessage() {
    if (hasMessage) {
      _speak(currentMessage);
    }
  }

  void selectCategory(AACCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void increaseTileSize() {
    if (_tileSize < 2.0) {
      _tileSize += 0.2;
      _savePreferences();
      notifyListeners();
    }
  }

  void decreaseTileSize() {
    if (_tileSize > 0.6) {
      _tileSize -= 0.2;
      _savePreferences();
      notifyListeners();
    }
  }

  void resetTileSize() {
    _tileSize = 1.0;
    _savePreferences();
    notifyListeners();
  }

  List<AACCategory> getAvailableCategories() {
    return AACCategory.values;
  }

  CommunicationMessage createMessage() {
    return CommunicationMessage(
      tiles: List.from(_selectedTiles),
      timestamp: DateTime.now(),
    );
  }

  void _speak(String text) {
    _ttsService.speak(text);
  }
}