
import '../services/database_service.dart';
import '../models/pf_ing_model.dart';
class PfingDao{
  final dbHelper = DatabaseService();
  Future<int> insertWord(PfIng word) async{
    final db=await dbHelper.database;
    return await db.insert('pfIng', word.toMap());
  }
  Future<List<PfIng>> getall() async {
    final db= await dbHelper.database;
    final respon=await db.query('pfIng');
    return respon.map((e)=>PfIng.fromMap(e)).toList();
  }

  Future<int> updateWord(PfIng word) async {
    final db = await dbHelper.database;
    return await db.update(
      'Pfing',
      word.toMap(),
      where: 'id=?',
      whereArgs: [word.id],
    );
  }

  Future<int> deleteWord(int id) async {
    final db= await dbHelper.database;
    return await db.delete(
      'PfIng',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}