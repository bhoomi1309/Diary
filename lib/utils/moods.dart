import 'dart:ui';
import 'package:flutter/material.dart';


// Global list of moods
final List<Map<String, String>> moods = [
  {'emoji': '😊', 'label': 'Happy'},
  {'emoji': '😢', 'label': 'Sad'},
  {'emoji': '😠', 'label': 'Angry'},
  {'emoji': '😌', 'label': 'Calm'},
  {'emoji': '🥰', 'label': 'Loved'},
  {'emoji': '😕', 'label': 'Confused'},
  {'emoji': '😎', 'label': 'Confident'},
];


// Mood mapping function
String mapScoreToMood(int score) {
  if (score >= 4) return '😎';         // Confident
  else if (score > 1) return '😊';     // Happy
  else if (score == 1) return '😌';    // Calm
  else if (score == 0) return '😕';    // Confused
  else if (score <= -4) return '😠';   // Angry
  else if (score < -1) return '😢';    // Sad
  else return '🥰';                    // Loved (score == -1)
}


//Background colors as per the mood
Color getMoodColor(String label) {
  switch (label.toLowerCase()) {
    case 'happy':
      return Colors.yellow.shade100;
    case 'sad':
      return Colors.blue.shade100;
    case 'angry':
      return Colors.red.shade100;
    case 'loved':
      return Colors.pink.shade100;
    case 'calm':
      return Colors.green.shade100;
    case 'confused':
      return Colors.orange.shade100;
    case 'confident':
      return Colors.purple.shade100;
    default:
      return Colors.grey.shade200;
  }
}


String getLabelFromEmoji(String emoji) {
  final mood = moods.firstWhere(
        (m) => m['emoji'] == emoji,
    orElse: () => {'label': 'Unknown'},
  );
  return mood['label']!;
}