// 在 test/repositories/post_repository_test.dart
import 'package:domains/entity/post/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/adapters/repository/post/post_repository_impl.dart';
import 'package:infra/datasources/remote/interfaces/post_remote_datasource.dart';
import 'package:mockito/mockito.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  group('PostRepositoryImpl', () {
    late PostRepositoryImpl repository;
    late MockPostRemoteDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockPostRemoteDataSource();
      repository = PostRepositoryImpl(mockDataSource);
    });

    test('getPosts should return list of posts when successful', () async {
      // Arrange
      final postsData = [
        {'id': '1', 'title': 'Test Post', 'body': 'Test Body'},
      ];
      when(mockDataSource.getPosts()).thenAnswer((_) async => postsData);

      // Act
      final result = await repository.getPosts();

      // Assert
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(result[0].title, 'Test Post');
      verify(mockDataSource.getPosts()).called(1);
    });
  });
}
