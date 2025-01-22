import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart' as dio;
import 'package:looptracker_mobile/app/controllers/auth/authentication_controller.dart';

class ApiService {
  static final String baseUrl = "${dotenv.env['API_SERVER_URL']}:${dotenv.env['API_SERVER_PORT']}/${dotenv.env['API_PREFIX']}";

  static final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
      validateStatus: (status) => status! < 500,
    ),
  );

  // Helper to build headers with JWT token from the AuthenticationController
  static Map<String, String> _buildHeaders() {
    final AuthenticationController authenticationController = Get.find();
    return {
      "Authorization": "Bearer ${authenticationController.jwtToken.value}",
      "Content-Type": "application/json",
    };
  }

  static Map<String, String> _buildHeadersFormData() {
    final AuthenticationController authenticationController = Get.find();
    return {
      "Authorization": "Bearer ${authenticationController.jwtToken.value}",
      "Content-Type": "multipart/form-data",
    };
  }

  // GET request
  static Future<dio.Response> getData(String endpoint, Map<String, String?>? queryParams) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: dio.Options(headers: _buildHeaders()),
      );
      return response;
    } catch (e) {
      print('GET Error: $e');
      return dio.Response(
        requestOptions: dio.RequestOptions(path: endpoint),
        statusCode: 500,
        statusMessage: 'GET Error',
      );
    }
  }

  // POST request
  static Future<dio.Response> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: jsonEncode(data),
        options: dio.Options(headers: _buildHeaders()),
      );
      return response;
    } catch (e) {
      print('POST Error: $e');
      return dio.Response(
        requestOptions: dio.RequestOptions(path: endpoint),
        statusCode: 500,
        statusMessage: 'POST Error',
      );
    }
  }

  // PUT request
  static Future<dio.Response> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: jsonEncode(data),
        options: dio.Options(headers: _buildHeaders()),
      );
      return response;
    } catch (e) {
      print('PUT Error: $e');
      return dio.Response(
        requestOptions: dio.RequestOptions(path: endpoint),
        statusCode: 500,
        statusMessage: 'PUT Error',
      );
    }
  }

  // DELETE request
  static Future<dio.Response> deleteData(String endpoint) async {
    try {
      final response = await _dio.delete(
        endpoint,
        options: dio.Options(headers: _buildHeaders()),
      );
      return response;
    } catch (e) {
      print('DELETE Error: $e');
      return dio.Response(
        requestOptions: dio.RequestOptions(path: endpoint),
        statusCode: 500,
        statusMessage: 'DELETE Error',
      );
    }
  }

  // POST request with FormData for file uploads
  static Future<dio.Response> postFormData(String endpoint, dio.FormData formData) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: dio.Options(headers: _buildHeadersFormData()),
      );
      return response;
    } catch (e) {
      print('POST FormData Error: $e');
      return dio.Response(
        requestOptions: dio.RequestOptions(path: endpoint),
        statusCode: 500,
        statusMessage: 'POST FormData Error',
      );
    }
  }

  static Future<dio.Response> putFormData(String endpoint, dio.FormData formData) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: formData,
        options: dio.Options(headers: _buildHeadersFormData()),
      );
      return response;
    } catch (e) {
      print('PUT FormData Error: ============================ $e');
      return dio.Response(
        requestOptions: dio.RequestOptions(path: endpoint),
        statusCode: 500,
        statusMessage: 'PUT FormData Error',
      );
    }
  }
}
