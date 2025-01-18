import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String apiUrl =
      "https://api.indataai.in/wereads/fetch_dairy.php"; // Replace with your backend URL

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
