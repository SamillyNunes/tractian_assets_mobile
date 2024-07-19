import 'package:dio/dio.dart';

const baseUrl = 'https://fake-api.tractian.com';

class ApiService {
  final Dio _dio;

  ApiService({required Dio dio}) : _dio = dio;

  Future<List<dynamic>> get({String? resource}) async {
    try {
      final url = resource != null ? '$baseUrl/$resource' : baseUrl;
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('API Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Something were wrong: $e');
    }
  }
}
