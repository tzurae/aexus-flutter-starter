// test/all_test.dart
import 'package:flutter_test/flutter_test.dart';

import '../packages/domains/test/all_domain_test.dart' as domain_tests;

void main() {
  group('Domain Tests', domain_tests.main);
  // group('Application Tests', application_tests.main);
  // group('Infrastructure Tests', infrastructure_tests.main);
  // group('Presentation Tests', presentation_tests.main);
}
