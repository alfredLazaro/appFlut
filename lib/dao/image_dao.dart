import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/image_model.dart';
class ImageDao{
  final dbHelper = DatabaseService();
  Future<int> insertImage(Image imag) async{
    final db=await dbHelper.database;
    return await db.insert('image',imag.toMap());
  }

  Future<List<Image>> getAllImgs() async {
    final db = await dbHelper.database;
    final result= await db.query('image');
    return result.map((json)=> Image.fromMap(json)).toList();
  }

  Future<int> updateImag(Image img) async {
    final db = await dbHelper.database;
    return await db.update(
      'image',
      img.toMap(),
      where: 'id = ?',
      whereArgs: [img.id],
    );
  }

  Future<int> deleteImag(int id) async{
    final db =await dbHelper.database;
    return await db.delete(
      'image',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Image?> getImagById(int id) async{
    final db= await dbHelper.database;
    final result =await db.query(
      'image',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty){
      return Image.fromMap(result.first);
    }
    return null;
  }
  Future<List<Image>> getByWordId(int id) async{
    final db= await dbHelper.database;
    final result=await db.query(
      'Image',
      where: 'wordId = ?',
      whereArgs: [id],
    );
    return result.map((e)=>Image.fromMap(e)).toList();
  }
  Future<int> deleteByWordId(int id) async{
    final db= await dbHelper.database;
    final result= await db.delete(
      'Image',
      where: 'wordId = ?',
      whereArgs: [id],
    );
    return result;
  }
}