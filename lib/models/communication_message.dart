import 'aac_tile.dart';

class CommunicationMessage {
  final List<AACTile> tiles;
  final DateTime timestamp;
  final String? customText;

  const CommunicationMessage({
    required this.tiles,
    required this.timestamp,
    this.customText,
  });

  String get fullMessage {
    if (customText != null && customText!.isNotEmpty) {
      return customText!;
    }
    return tiles.map((tile) => tile.text).join(' ');
  }

  bool get isEmpty => tiles.isEmpty && (customText == null || customText!.isEmpty);

  CommunicationMessage copyWith({
    List<AACTile>? tiles,
    DateTime? timestamp,
    String? customText,
  }) {
    return CommunicationMessage(
      tiles: tiles ?? this.tiles,
      timestamp: timestamp ?? this.timestamp,
      customText: customText ?? this.customText,
    );
  }

  Map<String, dynamic> toJson() => {
    'tiles': tiles.map((tile) => tile.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
    'customText': customText,
  };

  factory CommunicationMessage.fromJson(Map<String, dynamic> json) {
    return CommunicationMessage(
      tiles: (json['tiles'] as List)
          .map((tileJson) => AACTile.fromJson(tileJson))
          .toList(),
      timestamp: DateTime.parse(json['timestamp']),
      customText: json['customText'],
    );
  }
}