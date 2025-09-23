// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// Future initDatabase() async {
//   final dbPath = await getDatabasesPath();
//   final path = join(dbPath, 'my_app.db');

//   return openDatabase(
//     path,
//     version: 1,
//     onCreate: (db, v) async {
//       await db.execute('''
//         CREATE TABLE tasks(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT,
//         done INTEGER
//       )
//       ''');
//       await db.insert('my_table', {'column1': 'bbb', 'column2': 'aaa'});
//       await db.delete('my_table', where: 'id = ?', whereArgs: [1]);
//       await db.update('my_table', {'column1' : 'sss'}, where: 'id = ?', whereArgs: [1],);
//     },
//   );
// }
