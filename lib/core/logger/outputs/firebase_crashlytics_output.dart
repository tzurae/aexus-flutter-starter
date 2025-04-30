import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rizzlt_flutter_starter/core/logger/enum/LogLevel.dart';
import 'package:rizzlt_flutter_starter/core/logger/interface/output_interface.dart';
import 'package:rizzlt_flutter_starter/core/logger/log_event.dart';

class CrashlyticsOutput implements LogOutput {
  final FirebaseCrashlytics _crashlytics;
  final Set<LogLevel> _reportLevels;
  CrashlyticsOutput({
    required FirebaseCrashlytics crashlytics,
    required Set<LogLevel> reportLevels,
  })  : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance,
        _reportLevels = reportLevels ?? {LogLevel.error, LogLevel.fatal};
  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<void> destroy() {
    throw UnimplementedError();
  }

  @override
  Future<void> init() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
  }

  @override
  Future<void> output(LogEvent event) {
    // TODO: implement output
    throw UnimplementedError();
  }

  // @override
  // void output(LogEvent event) async {
  // if (!_reportLevels.contains(event.origin.level)) return;
  // await _crashlytics.log('${event.lines ?? 'APP'}: ${event.origin.message}');
  // if (event.origin.error != null) {
  //   await _crashlytics.recordError(
  //     event.origin.error,
  //     event.origin.stackTrace,
  //     reason: event.origin.message,
  //   );
  // }
  // }
}
