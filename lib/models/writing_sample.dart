import 'dart:convert';

enum WritingMode { tracing, copying, dictation, creative }

class WritingSample {
  final DateTime date;
  final WritingMode mode;
  final String content; // User-written text (or notes)
  final String? target; // Target letter/word/sentence if applicable
  final int wordCount;
  final double? accuracy; // 0..1 for tracing/copying
  final int? durationMs;
  final Map<String, dynamic>? mistakes; // e.g., substitutions, omissions

  WritingSample({
    required this.date,
    required this.mode,
    required this.content,
    this.target,
    required this.wordCount,
    this.accuracy,
    this.durationMs,
    this.mistakes,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'mode': mode.name,
        'content': content,
        'target': target,
        'wordCount': wordCount,
        'accuracy': accuracy,
        'durationMs': durationMs,
        'mistakes': mistakes,
      };

  static WritingSample fromJson(Map<String, dynamic> json) => WritingSample(
        date: DateTime.parse(json['date'] as String),
        mode: WritingMode.values.firstWhere(
            (m) => m.name == (json['mode'] as String? ?? 'creative'),
            orElse: () => WritingMode.creative),
        content: json['content'] as String? ?? '',
        target: json['target'] as String?,
        wordCount: json['wordCount'] as int? ?? 0,
        accuracy: (json['accuracy'] as num?)?.toDouble(),
        durationMs: json['durationMs'] as int?,
        mistakes: (json['mistakes'] as Map?)?.cast<String, dynamic>(),
      );

  static String encodeList(List<WritingSample> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<WritingSample> decodeList(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(WritingSample.fromJson)
        .toList();
  }
}

