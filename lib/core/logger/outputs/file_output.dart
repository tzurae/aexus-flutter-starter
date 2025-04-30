// import 'dart:io';
//
// import 'package:intl/intl.dart';
// import 'package:logger/src/output_event.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
//
// class FileLogOutput extends LogOutputInterface {
//   final String _fileName;
//   final int _maxFileSize; // 最大文件大小（字節）
//   final int _maxHistoryFiles; // 最大歷史文件數量
//
//   IOSink? _sink;
//   File? _file;
//
//   FileLogOutput({
//     String fileName = 'app_logs',
//     int maxFileSize = 1024 * 1024 * 10, // 10MB
//     int maxHistoryFiles = 5,
//   })  : _fileName = fileName,
//         _maxFileSize = maxFileSize,
//         _maxHistoryFiles = maxHistoryFiles;
//
//   @override
//   Future<void> init() async {
//     final directory = await _getLogDirectory();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     _file = File('${directory.path}/${_fileName}_$today.log');
//
//     // 檢查文件大小，如果超過限制則進行滾動
//     if (await _file!.exists() && await _file!.length() > _maxFileSize) {
//       await _rolloverLogFile();
//     }
//
//     _sink = _file!.openWrite(mode: FileMode.append);
//   }
//
//   @override
//   void output(OutputEvent event) {
//     if (_sink == null) return;
//
//     for (var line in event.lines) {
//       _sink!.writeln(
//           '${DateFormat('HH:mm:ss.SSS').format(DateTime.now())} $line');
//     }
//   }
//
//   @override
//   Future<void> close() async {
//     await _sink?.flush();
//     await _sink?.close();
//     _sink = null;
//   }
//
//   Future<Directory> _getLogDirectory() async {
//     final appDir = await getApplicationDocumentsDirectory();
//     final logDir = Directory('${appDir.path}/logs');
//
//     if (!await logDir.exists()) {
//       await logDir.create(recursive: true);
//     }
//
//     return logDir;
//   }
//
//   Future<void> _rolloverLogFile() async {
//     if (_file == null) return;
//
//     final directory = await _getLogDirectory();
//     final baseName = '${directory.path}/$_fileName';
//
//     // 刪除最舊的日誌文件（如果達到最大數量）
//     final logFiles = directory
//         .listSync()
//         .whereType<File>()
//         .where((file) => file.path.contains(_fileName))
//         .toList()
//       ..sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
//
//     while (logFiles.length >= _maxHistoryFiles) {
//       final oldestFile = logFiles.removeAt(0);
//       await oldestFile.delete();
//     }
//
//     // 重命名當前文件
//     final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
//     await _file!.rename('${baseName}_$timestamp.log');
//   }
// }
