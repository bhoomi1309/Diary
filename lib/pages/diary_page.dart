import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_functions.dart';
import '../utils/moods.dart';
import 'add_new_entry.dart';

class DiaryPage extends StatefulWidget {
  final int id;

  const DiaryPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DiaryEntry? entry;

  Future<void> _loadEntryById() async {
    final dao = DiaryDao();
    DiaryEntry? diaryEntry = await dao.getEntryById(widget.id);
    setState(() {
      entry = diaryEntry;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEntryById();
  }

  @override
  Widget build(BuildContext context) {
    final Color moodColor = entry != null
        ? getMoodColor(entry!.label)
        : Theme.of(context).colorScheme.primary;
    final Color textColor =
        entry != null ? getMoodTextColor(entry!.label) : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary Entry"),
        backgroundColor: moodColor,
        foregroundColor: textColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewEntry(id: widget.id),
                ),
              );
              if (result == true) {
                setState(() {
                  _loadEntryById();
                });
              }
            },
          ),
        ],
      ),
      body: entry == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: moodColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily:
                          Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    ),
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
                                  entry!.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: textColor),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('MMMM d, yyyy')
                                      .format(DateTime.parse(entry!.date)),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Hero(
                              tag: 'emoji_${entry?.id}',
                              child: Text(
                                entry!.emoji,
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          entry!.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
