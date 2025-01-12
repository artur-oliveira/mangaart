import 'package:dio/dio.dart';

class HttpClient {
  final Dio _dio;

  HttpClient(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ));

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParams);
    } catch (e) {
      throw Exception('Failed to GET: \$e');
    }
  }

// Add other methods (POST, PUT, DELETE) if needed.
}
