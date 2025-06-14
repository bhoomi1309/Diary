import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/moods.dart';
import 'add_new_entry.dart';

class DiaryPage extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final String label;
  final String emoji;

  const DiaryPage({
    Key? key,
    required this.title,
    required this.date,
    required this.content,
    required this.emoji,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color moodColor = getMoodColor(label);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary Entry"),
        backgroundColor: moodColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final DateFormat formatter = DateFormat('MMMM d, yyyy');
              final DateTime parsedDate = formatter.parse(date);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewEntry(
                    title: title,
                    content: content,
                    emoji: emoji,
                    label: label,
                    date: parsedDate,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: moodColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          date,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.yellow.shade200,
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}