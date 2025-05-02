import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:rizzlt_flutter_starter/core/bootstrap/app_bootstrap.dart';

export 'package:get_it/get_it.dart';
export 'package:multiple_result/multiple_result.dart';
export 'package:rizzlt_flutter_starter/core/logger/logger_factory.dart';
export 'package:validators/validators.dart';

Future<void> main() async {
  await AppBootstrap.instance.initialize();
  runApp(MyApp());
}
