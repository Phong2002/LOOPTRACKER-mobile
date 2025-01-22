import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class ApiAdministrativeUnit {
  final String? ghnApiUrl = dotenv.env['GHN_API_URL'];
  final String? ghnToken = dotenv.env['GHN_TOKEN'];

  final Dio _dio = Dio();

  ApiAdministrativeUnit() {
    _dio.options.baseUrl = ghnApiUrl!;
    _dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    _dio.options.headers['Token'] = ghnToken!;
  }

  Future<Response> getAdministrativeUnit(String endpoint, Map<String, dynamic> param) async {
    try {
      print("==========================${_dio.options.baseUrl}----------------$endpoint");
      // Gọi API với Dio
      Response response = await _dio.get(endpoint, queryParameters: param);


      print("-------------------------------");
      print(response.headers['content-type']);
      print("-------------------------------");
      return response;
    } on DioError catch (e) {
      // Xử lý lỗi nếu có
      print('DioError: ${e.response?.statusCode} - ${e.message}');

      throw Exception('Failed to get data');
    }
  }
}
