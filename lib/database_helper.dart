import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cards.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        suit TEXT NOT NULL,
        image_url TEXT NOT NULL,
        folder_id INTEGER,
        FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    await _insertDefaultFolders(db);
    await _insertDefaultCards(db);
  }

  Future<void> _insertDefaultFolders(Database db) async {
    List<String> suits = ["Hearts", "Spades", "Diamonds", "Clubs"];
    for (String suit in suits) {
      await db.insert('folders', {'name': suit});
    }
  }

  Future<void> _insertDefaultCards(Database db) async {
    List<String> suits = ["Hearts", "Spades", "Diamonds", "Clubs"];
    for (String suit in suits) {
      for (int i = 1; i <= 13; i++) {
        String cardName = (i == 1)
            ? "Ace of $suit"
            : (i == 11)
            ? "Jack of $suit"
            : (i == 12)
            ? "Queen of $suit"
            : (i == 13)
            ? "King of $suit"
            : "$i of $suit";

        String imageUrl = "https://example.com/cards/$suit/$i.png";

        await db.insert('cards', {
          'name': cardName,
          'suit': suit,
          'image_url': imageUrl,
          'folder_id': null
        });
      }
    }
  }

  Future<void> closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
