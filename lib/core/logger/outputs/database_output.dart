// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:rizzlt_flutter_starter/core/logger/interface/log_output.dart';
// import 'package:rizzlt_flutter_starter/core/logger/interface/log_event.dart';
//
// class DatabaseOutput implements LogOutput {
//   final String _databaseName;
//   final int _maxEntries;
//   Database? _database;
//
//   DatabaseOutput({
//     String databaseName = 'app_logs.db',
//     int maxEntries = 1000,
//   }) : _databaseName = databaseName,
//         _maxEntries = maxEntries;
//
//   @override
//   Future<void> init() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, _databaseName);
//
//     _database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute('''
//           CREATE TABLE logs (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             timestamp TEXT NOT NULL,
//             level TEXT NOT NULL,
//             tag TEXT,
//             message TEXT NOT NULL,
//             error TEXT,
//             stack_trace TEXT,
//             context TEXT
//           )
//         ''');
//       },
//     );
//
//     // 清理舊日誌
//     await _cleanupOldLogs();
//   }
//
//   @override
//   Future<void> output(LogEvent event) async {
//     if (_database == null) return;
//
//     await _database!.insert('logs', {
//       'timestamp': event.time.toIso8601String(),
//       'level': event.level.toString().split('.').last,
//       'tag': event.tag,
//       'message': event.message,
//       'error': event.error?.toString(),
//       'stack_trace': event.stackTrace?.toString(),
//       'context': event.context != null ?
//       event.context!.entries.map((e) => '${e.key}=${e.value}').join(';') :
//       null,
//     });
//
//     // 定期清理舊日誌
//     if (await _database!.rawQuery('SELECT COUNT(*) FROM logs')
//         .then((value) => Sqflite.firstIntValue(value) ?? 0) > _maxEntries * 1.2) {
//       await _cleanupOldLogs();
//     }
//   }
//
//   Future<void> _cleanupOldLogs() async {
//     if (_database == null) return;
//
//     // 刪除最舊的日誌，只保留最新的 _maxEntries 條
//     await _database!.execute('''
//       DELETE FROM logs
//       WHERE id NOT IN (
//         SELECT id FROM logs
//         ORDER BY timestamp DESC
//         LIMIT $_maxEntries
//       )
//     ''');
//   }
//
//   @override
//   Future<void> close() async {
//     await _database?.close();
//     _database = null;
//   }
// }
