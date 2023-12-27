import 'package:sqflite/sqflite.dart';
import 'package:voicify/main.dart';

Future<void> deleteSessionRecord({required int id}) async {
  await database.rawDelete('DELETE FROM Sessions WHERE id = ?', ['$id']);
}

Future<void> initializeDatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = '${databasesPath}/sessions.db';

  // open the database
  database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Sessions (id INTEGER PRIMARY KEY, title TEXT, body TEXT, created_on TIMESTAMP)');
  });
}
