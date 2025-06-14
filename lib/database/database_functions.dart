import 'package:sqflite/sqflite.dart';
import 'diary_database.dart';

class DiaryEntry {
  final int? id;
  final String title;
  final String date;
  final String emoji;
  final String label;
  final String content;

  DiaryEntry({
    this.id,
    required this.title,
    required this.date,
    required this.emoji,
    required this.label,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      DiaryDatabase.ID: id,
      DiaryDatabase.TITLE: title,
      DiaryDatabase.DATE: date,
      DiaryDatabase.EMOJI: emoji,
      DiaryDatabase.LABEL: label,
      DiaryDatabase.CONTENT: content,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map[DiaryDatabase.ID],
      title: map[DiaryDatabase.TITLE],
      date: map[DiaryDatabase.DATE],
      emoji: map[DiaryDatabase.EMOJI],
      label: map[DiaryDatabase.LABEL],
      content: map[DiaryDatabase.CONTENT],
    );
  }
}

class DiaryDao {
  Future<int> insertEntry(DiaryEntry entry) async {
    final db = await DiaryDatabase().initDatabase();
    return await db.insert(DiaryDatabase.TBL_DIARY, entry.toMap());
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    final db = await DiaryDatabase().initDatabase();
    final List<Map<String, dynamic>> maps =
    await db.query(DiaryDatabase.TBL_DIARY, orderBy: '${DiaryDatabase.DATE} DESC');
    return List.generate(maps.length, (i) => DiaryEntry.fromMap(maps[i]));
  }

  Future<int> updateEntry(DiaryEntry entry) async {
    final db = await DiaryDatabase().initDatabase();
    return await db.update(
      DiaryDatabase.TBL_DIARY,
      entry.toMap(),
      where: '${DiaryDatabase.ID} = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await DiaryDatabase().initDatabase();
    return await db.delete(
      DiaryDatabase.TBL_DIARY,
      where: '${DiaryDatabase.ID} = ?',
      whereArgs: [id],
    );
  }
}