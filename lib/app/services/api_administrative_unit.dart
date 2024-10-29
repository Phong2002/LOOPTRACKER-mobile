import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiAdministrativeUnit {
  final String? ghnApiUrl = dotenv.env['GHN_API_URL'];
  final String? ghnToken = dotenv.env['GHN_TOKEN'];

  Future<http.Response> getAdministrativeUnit(String endpoint, Map<String, dynamic> param) async {
    final response = await http.get(
      Uri.parse('$ghnApiUrl/$endpoint').replace(queryParameters:param),
      headers: {"Content-Type": "application/json; charset=UTF-8'",'Token': ghnToken!},
    );
    if (response.statusCode == 200) {
      print("-------------------------------");
      print(response.headers['content-type']);
      print("-------------------------------");
      return response;
    } else {
      throw Exception('Failed to post data');
    }
  }

}
