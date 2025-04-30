class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    try {
      return User(
        id: map['id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
      );
    } catch (e, stack) {
      print('Error parsing User from map: $map');
      print('Error details: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }
}
