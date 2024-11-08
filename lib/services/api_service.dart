import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_login.dart';
import '../strings/constants.dart';

class ApiService {
  Future<UserLogin?> login(String username, String password) async {
    final url = Uri.parse('$apiUrl/$apiVersion/auth/authenticate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserLogin.fromJson(json); // Decodifica la respuesta con los nuevos campos
    } else {
      return null; // Manejo de errores si la autenticación falla
    }
  }
}
