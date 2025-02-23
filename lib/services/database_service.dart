import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pf_ing_model.dart';

class DatabaseService {
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
        final path = join(dbPath, 'pfIng.db');

        return await openDatabase(
            path,
            version: 1,
            onCreate: _onCreate,
        );
    }

    Future<void> _onCreate(Database db, int version) async {
        await db.execute('''
            CREATE TABLE pfIng(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                word TEXT NOT NULL,
                sentence TEXT NOT NULL
            )
        ''');
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