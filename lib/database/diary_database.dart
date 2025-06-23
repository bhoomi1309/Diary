import 'package:sqflite/sqflite.dart';

class DiaryDatabase {

  // region DB CONSTANTS

  static const String TBL_DIARY = 'DiaryEntries';

  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String DATE = 'date';
  static const String EMOJI = 'emoji';
  static const String LABEL = 'label';
  static const String CONTENT = 'content';

  // endregion

  int DB_VERSION = 1;

  // region INIT DATABASE

  Future<Database> initDatabase() async {
    Database db = await openDatabase(
      '${await getDatabasesPath()}/Diary.db',
      version: DB_VERSION,
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE $TBL_DIARY (
            $ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $TITLE TEXT NOT NULL,
            $DATE TEXT NOT NULL,
            $EMOJI TEXT NOT NULL,
            $LABEL TEXT NOT NULL,
            $CONTENT TEXT NOT NULL
          );
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < DB_VERSION) {
          await db.execute('DROP TABLE IF EXISTS $TBL_DIARY;');
          await db.execute(
            '''
            CREATE TABLE $TBL_DIARY (
              $ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              $TITLE TEXT NOT NULL,
              $DATE TEXT NOT NULL,
              $EMOJI TEXT NOT NULL,
              $LABEL TEXT NOT NULL,
              $CONTENT TEXT NOT NULL
            );
            ''',
          );
          print("Database upgraded from $oldVersion to $newVersion: Dropped and recreated DiaryEntries table.");
        }
      },
    );
    return db;
  }

  // endregion
}