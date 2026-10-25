import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final base = await getDatabasesPath();
    _db = await openDatabase(
      p.join(base, 'ayur_sathi.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE journal(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TEXT NOT NULL,
            mood TEXT NOT NULL,
            energy INTEGER NOT NULL,
            sleep_hours REAL NOT NULL,
            note TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE routine_checks(
            day_key TEXT NOT NULL,
            item_key TEXT NOT NULL,
            done INTEGER NOT NULL,
            PRIMARY KEY(day_key, item_key)
          )
        ''');
        await db.execute('''
          CREATE TABLE prakriti_results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TEXT NOT NULL,
            vata INTEGER NOT NULL,
            pitta INTEGER NOT NULL,
            kapha INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<Map<String, Object?>>> getJournal() async {
    final db = await database;
    return db.query('journal', orderBy: 'id DESC');
  }

  Future<void> addJournal({
    required String mood,
    required int energy,
    required double sleepHours,
    required String note,
  }) async {
    final db = await database;
    await db.insert('journal', {
      'created_at': DateTime.now().toIso8601String(),
      'mood': mood,
      'energy': energy,
      'sleep_hours': sleepHours,
      'note': note,
    });
  }

  Future<void> deleteJournal(int id) async {
    final db = await database;
    await db.delete('journal', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> routineDone(String dayKey, String itemKey) async {
    final db = await database;
    final rows = await db.query('routine_checks',
        where: 'day_key = ? AND item_key = ?', whereArgs: [dayKey, itemKey]);
    return rows.isNotEmpty && rows.first['done'] == 1;
  }

  Future<void> setRoutine(String dayKey, String itemKey, bool done) async {
    final db = await database;
    await db.insert('routine_checks', {
      'day_key': dayKey,
      'item_key': itemKey,
      'done': done ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> addPrakritiResult(int vata, int pitta, int kapha) async {
    final db = await database;
    await db.insert('prakriti_results', {
      'created_at': DateTime.now().toIso8601String(),
      'vata': vata, 'pitta': pitta, 'kapha': kapha,
    });
  }
}
