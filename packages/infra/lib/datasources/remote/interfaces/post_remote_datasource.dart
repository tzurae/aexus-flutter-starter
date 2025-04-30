abstract class PostRemoteDataSource {
  Future<List<Map<String, dynamic>>> getPosts({
    int? limit,
    int? offset,
    String? searchQuery,
  });
}
