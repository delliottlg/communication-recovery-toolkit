import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/writing_sample.dart';
import '../utils/text_similarity.dart';

class WritingProvider extends ChangeNotifier {
  // UI options
  double fontSize = 96;
  bool showLineGuides = true;
  bool leftHanded = false;
  bool timerEnabled = false;

  // Mode
  WritingMode mode = WritingMode.tracing;

  // Tracing state
  String currentChar = 'A';
  bool lowercase = false;
  bool includeNumbers = true;

  // Copying state
  String currentCategory = 'family';
  int minLen = 3;
  int maxLen = 6;
  String targetWord = 'mom';

  // Dictation state
  String dictationTarget = 'hello';
  bool dictationSentence = false;

  // Timer
  DateTime? _timerStart;
  int elapsedMs = 0; // accumulates when stopped

  // History
  final List<WritingSample> _history = [];
  List<WritingSample> get history => List.unmodifiable(_history);

  // Word lists
  static const Map<String, List<String>> _words = {
    'family': ['mom', 'dad', 'baby', 'grandma', 'grandpa', 'sister', 'brother', 'cousin', 'aunt', 'uncle', 'family'],
    'food': ['egg', 'milk', 'bread', 'apple', 'banana', 'cheese', 'pasta', 'chicken', 'salad', 'yogurt', 'sandwich', 'chocolate'],
    'daily': ['walk', 'read', 'sleep', 'brush', 'dress', 'school', 'write', 'play', 'listen', 'clean', 'homework', 'computer']
  };

  static final List<String> _sentences = [
    'Please close the door.',
    'I like to read books.',
    'We are going for a walk.',
    'The weather is sunny today.',
    'Dinner is ready at six.'
  ];

  WritingProvider() {
    _load();
    _pickNewTargets();
  }

  void setMode(WritingMode m) {
    mode = m;
    notifyListeners();
  }

  void toggleLowercase(bool v) {
    lowercase = v;
    if (!includeNumbers) {
      currentChar = lowercase ? 'a' : 'A';
    } else {
      currentChar = lowercase ? 'a' : 'A';
    }
    notifyListeners();
  }

  void setIncludeNumbers(bool v) {
    includeNumbers = v;
    if (includeNumbers) {
      currentChar = '0';
    } else {
      currentChar = lowercase ? 'a' : 'A';
    }
    notifyListeners();
  }

  void nextChar() {
    final list = _charList();
    final idx = list.indexOf(currentChar);
    currentChar = list[(idx + 1) % list.length];
    notifyListeners();
  }

  void prevChar() {
    final list = _charList();
    final idx = list.indexOf(currentChar);
    currentChar = list[(idx - 1 + list.length) % list.length];
    notifyListeners();
  }

  List<String> _charList() {
    final letters = lowercase
        ? List<String>.generate(26, (i) => String.fromCharCode('a'.codeUnitAt(0) + i))
        : List<String>.generate(26, (i) => String.fromCharCode('A'.codeUnitAt(0) + i));
    final numbers = List<String>.generate(10, (i) => '$i');
    return includeNumbers ? [...letters, ...numbers] : letters;
  }

  void setCategory(String cat) {
    currentCategory = cat;
    _pickNewTargets();
    notifyListeners();
  }

  void setDifficultyRange(int min, int max) {
    minLen = min; maxLen = max;
    _pickNewTargets();
    notifyListeners();
  }

  void _pickNewTargets() {
    final list = _words[currentCategory] ?? _words.values.first;
    final filtered = list.where((w) => w.length >= minLen && w.length <= maxLen).toList();
    if (filtered.isEmpty) {
      targetWord = list.first;
    } else {
      filtered.shuffle();
      targetWord = filtered.first;
    }

    dictationSentence = (minLen >= 7); // rough progression toggle
    if (dictationSentence) {
      _sentences.shuffle();
      dictationTarget = _sentences.first;
    } else {
      final pool = _words.values.expand((e) => e).toList();
      pool.shuffle();
      dictationTarget = pool.first;
    }
  }

  void setFontSize(double size) { fontSize = size; notifyListeners(); }
  void setLineGuides(bool v) { showLineGuides = v; notifyListeners(); }
  void setLeftHanded(bool v) { leftHanded = v; notifyListeners(); }
  void setTimerEnabled(bool v) { timerEnabled = v; notifyListeners(); }

  void startTimer() { _timerStart = DateTime.now(); elapsedMs = 0; notifyListeners(); }
  void stopTimer() { if (_timerStart!=null){ elapsedMs = DateTime.now().difference(_timerStart!).inMilliseconds; _timerStart=null; notifyListeners(); } }
  bool get isTiming => _timerStart != null;

  Future<void> recordSample({required WritingMode mode, required String content, String? target, double? accuracy, Map<String,dynamic>? mistakes}) async {
    final sample = WritingSample(
      date: DateTime.now(),
      mode: mode,
      content: content,
      target: target,
      wordCount: content.trim().isEmpty ? 0 : content.trim().split(RegExp(r"\s+")).length,
      accuracy: accuracy,
      durationMs: elapsedMs,
      mistakes: mistakes,
    );
    _history.insert(0, sample);
    await _save();
    notifyListeners();
  }

  double copyingAccuracy(String input) {
    return TextSimilarity.similarity(targetWord, input);
  }

  Map<String,dynamic> copyingMistakes(String input) {
    return TextSimilarity.analyze(targetWord, input);
  }

  double dictationAccuracy(String input) {
    return TextSimilarity.similarity(dictationTarget, input);
  }

  Map<String,dynamic> dictationMistakes(String input) {
    return TextSimilarity.analyze(dictationTarget, input);
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('writing_history', WritingSample.encodeList(_history));
      await prefs.setDouble('writing_font_size', fontSize);
      await prefs.setBool('writing_line_guides', showLineGuides);
      await prefs.setBool('writing_left_handed', leftHanded);
    } catch (_) {}
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      fontSize = prefs.getDouble('writing_font_size') ?? fontSize;
      showLineGuides = prefs.getBool('writing_line_guides') ?? showLineGuides;
      leftHanded = prefs.getBool('writing_left_handed') ?? leftHanded;
      final listStr = prefs.getString('writing_history');
      _history
        ..clear()
        ..addAll(WritingSample.decodeList(listStr));
      notifyListeners();
    } catch (_) {}
  }
}
