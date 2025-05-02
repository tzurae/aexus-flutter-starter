import 'package:domains/entity/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void userTests() {
  group('User Entity', () {
    test('should create user with correct values', () {
      final user = User(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
      );
      expect(user.id, '1');
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
    });
  });
}
