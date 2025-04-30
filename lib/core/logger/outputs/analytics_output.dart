// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:logger/logger.dart';
//
// class AnalyticsOutput implements LogOutput {
//   final FirebaseAnalytics _analytics;
//   final String _eventPrefix;
//
//   AnalyticsOutput({
//     FirebaseAnalytics? analytics,
//     String eventPrefix = 'log_',
//   })  : _analytics = analytics ?? FirebaseAnalytics.instance,
//         _eventPrefix = eventPrefix;
//
//   @override
//   Future<void> init() async {
//     // 無需特殊初始化
//   }
//
//   @override
//   Future<void> output(LogEvent event) async {
//     // 只處理帶有特定上下文標記的日誌事件
//     if (event.context == null || !event.context!.containsKey('track_event')) {
//       return;
//     }
//
//     // 從上下文中獲取事件名稱，或使用默認名稱
//     final eventName = event.context!['event_name'] as String? ??
//         '${_eventPrefix}${event.level.toString().split('.').last.toLowerCase()}';
//
//     // 準備事件參數
//     final params = <String, dynamic>{
//       'message': event.message,
//       'level': event.level.toString().split('.').last,
//     };
//
//     // 添加標籤（如果有）
//     if (event.tag != null) {
//       params['tag'] = event.tag;
//     }
//
//     // 添加其他上下文參數（排除特殊控制參數）
//     event.context!.forEach((key, value) {
//       if (key != 'track_event' && key != 'event_name' && value is String) {
//         params[key] = value;
//       }
//     });
//
//     // 記錄分析事件
//     await _analytics.logEvent(
//       name: eventName,
//       parameters: params,
//     );
//   }
//
//   @override
//   Future<void> close() async {
//     // 無需特殊清理
//   }
//
//   @override
//   Future<void> destroy() {
//     // TODO: implement destroy
//     throw UnimplementedError();
//   }
// }
