import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    //Local onde vai armazenar arquivos do BD;
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      //Esse comando vai ser executado uma unica vez na criação do BD;
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)',
        );
      },
      version: 1,
    );
  }

  //Inserir dados no BD
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  //Obter os dados no BD
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
