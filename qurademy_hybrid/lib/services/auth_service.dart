import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // for debugPrint

class AuthService {
  static const String _baseUrl = 'https://qurademy.com/api';

  // 🔹 Common response handler
  static Map<String, dynamic> _handleResponse(http.Response response) {
    debugPrint("➡️ [HTTP ${response.statusCode}] ${response.request?.url}");
    debugPrint("📥 Response Body: ${response.body}");

    try {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        json.decode(response.body),
      );

      if (response.statusCode == 200) {
        final bool success = data['success'] == true;

        final Map<String, dynamic> cleanData = Map<String, dynamic>.from(data);
        cleanData.removeWhere((key, _) => key == 'success' || key == 'message');

        return {
          'success': success,
          'message': data['message'] ?? (success ? 'Success' : 'Failed'),
          'data': cleanData,
        };
      } else {
        return {
          'success': false,
          'message':
              data['error'] ?? data['message'] ?? 'Server error occurred',
          'data': {},
        };
      }
    } catch (e) {
      debugPrint("❌ JSON Parse Error: $e");
      return {
        'success': false,
        'message': 'Invalid server response',
        'data': {},
      };
    }
  }

  // 🔹 Login - FIXED to send JSON like Postman
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔑 Sending Login Request...");
      debugPrint("➡️ URL: $_baseUrl/login.php");
      debugPrint("📤 Body: {email: $email, password: ******}");

      final response = await http
          .post(
            Uri.parse('$_baseUrl/login.php'),
            headers: {
              'Content-Type': 'application/json', // 🔥 Added JSON header
            },
            body: jsonEncode({
              // 🔥 Send as JSON, not form data
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      debugPrint("❌ Login Error: $e");
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
        'data': {},
      };
    }
  }

  // 🔹 Register
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/register.php'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'full_name': fullName,
              'username': username,
              'email': email,
              'password': password,
              'user_type': userType,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
        'data': {},
      };
    }
  }
}
