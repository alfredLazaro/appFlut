import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pf_ing_model.dart';

class DatabaseService {

    static const _databaseName= "database.db";
    static final DatabaseService _instance = DatabaseService._internal();
    static Database? _database;

    factory DatabaseService(){
        return _instance;
    }
    DatabaseService._internal();

    Future<Database> get database async {
        if (_database != null) return _database!;
        _database =await _initDatabase();
        print("base de datos creada correctamente");
        return _database!;
    }
    Future<Database> _initDatabase() async {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, _databaseName);

        return await openDatabase(
            path,
            version: 2,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
        );
    }

    Future<void> _onCreate(Database db, int version) async {
        await db.execute('''
            CREATE TABLE pfIng(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                definicion TEXT NOT NULL,
                word TEXT NOT NULL,
                wordTranslat TEXT,
                sentence TEXT NOT NULL,
                learn INTEGER NOT NULL DEFAULT 0,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''');
        await db.execute('''
            CREATE TABLE Image(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                wordId INTEGER,
                name TEXT,
                url TEXT,
                author TEXT,
                source TEXT,
                FOREIGN KEY (wordId) REFERENCES pfIng(id) ON DELETE CASCADE
            )
        ''');
    }

    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
            await db.execute('ALTER TABLE pfIng ADD COLUMN learn INTEGER NOT NULL DEFAULT 0');
        }
    }


    Future<void> insertPfIng(PfIng pfIng) async {
        final db = await database;
        await db.insert(
            'pfIng',
            pfIng.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("palabra insertada");
    }

    Future<List<PfIng>> getAllPfIng() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('pfIng');

        return List.generate(maps.length, (i){
            return PfIng.fromMap(maps[i]);
        });
    }

    Future<void> updatePfIng(PfIng pfIng) async {
        final db = await database;
        pfIng.updatedAt = DateTime.now().toIso8601String();
        await db.update(
            'pfIng',
            pfIng.toMap(),
            where: 'id = ?',
            whereArgs: [pfIng.id],
        );
    }

    Future<void> deletePfIng(int id) async {
        final db = await database;
        await db.delete(
            'pfIng',
            where: 'id = ?',
            whereArgs: [id],
        );
    }
}