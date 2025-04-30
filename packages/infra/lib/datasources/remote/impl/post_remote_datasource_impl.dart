// packages/infra/lib/datasources/remote/post_remote_datasource_impl.dart
import 'package:infra/clients/dio/dio_client.dart';
import 'package:infra/core/exceptions/network_exceptions.dart';
import 'package:infra/datasources/remote/constants/endpoints.dart';
import 'package:infra/datasources/remote/interfaces/post_remote_datasource.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient _dioClient;

  PostRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<Map<String, dynamic>>> getPosts(
      {int? limit, int? offset, String? searchQuery}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (searchQuery != null) queryParams['search'] = searchQuery;

      final res = await _dioClient.dio.get(
        Endpoints.getPosts,
        queryParameters: queryParams,
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw NetworkException(
          message: 'Failed to load posts: ${res.statusCode}',
        );
      }
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw NetworkException(
        message: 'DataSource: Failed to load posts: ${e.toString()}',
      );
    }
  }
}
