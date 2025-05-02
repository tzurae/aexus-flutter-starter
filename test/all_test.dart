// test/all_test.dart
import 'package:flutter_test/flutter_test.dart';

import '../packages/applications/test/all_application_test.dart'
    as application_tests;
import '../packages/domains/test/all_domain_test.dart' as domain_tests;
// import '../packages/infrastructure/test/all_infrastructure_test.dart' as infrastructure_tests;
// import '../packages/presentation/test/all_presentation_test.dart' as presentation_tests;

void main() {
  group('Domain Tests', domain_tests.main);
  group('Application Tests', application_tests.main);
  // group('Infrastructure Tests', infrastructure_tests.main);
  // group('Presentation Tests', presentation_tests.main);
}
