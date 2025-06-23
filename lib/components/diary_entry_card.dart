import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';

import '../database/database_functions.dart';
import '../pages/diary_page.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback? onDeleted;
  final bool showDate;
  final bool heroOnEmoji;

  const DiaryEntryCard({
    Key? key,
    required this.entry,
    this.onDeleted,
    this.showDate = true,
    this.heroOnEmoji = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 600),
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) => DiaryPage(id: entry.id!),
      closedColor: Colors.transparent,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFCE4EC), Color(0xFFE3F2FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: EdgeInsets.all(showDate ? 20 : 18),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded,
                        size: showDate ? 32 : 24,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.title,
                            style: showDate
                                ? Theme.of(context).textTheme.titleLarge
                                : const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                          ),
                          if (showDate) ...[
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMMM d, yyyy')
                                  .format(DateTime.parse(entry.date)),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    heroOnEmoji
                        ? Hero(
                            tag: 'emoji_${entry.id}',
                            child: Text(
                              entry.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                          )
                        : Text(
                            entry.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                  ],
                ),
                SizedBox(height: showDate ? 24 : 8),
                Text(
                  entry.content,
                  maxLines: showDate ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: showDate
                      ? Theme.of(context).textTheme.bodyMedium
                      : TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
