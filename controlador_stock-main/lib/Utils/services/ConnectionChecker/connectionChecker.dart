import 'package:http/http.dart' as http;

class ConnectionChecker {
  static Future<bool> checkConnection() async {
    try {
      final response = await http.get(Uri.parse('https://cloud.appwrite.io'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
