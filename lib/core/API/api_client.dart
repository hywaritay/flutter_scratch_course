import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Exception/ApiException.dart';
import 'Models/LoginRequest.dart';
import 'Models/LoginResponse.dart';


class ApiClient {
  static const String baseUrl =
      'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Generic POST request method
  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = {'Content-Type': 'application/json', ...?headers};

      final response = await _client
          .post(url, headers: requestHeaders, body: jsonEncode(body))
          .timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Login function
  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final responseData = await _post('/auth/login', request.toJson());
      return LoginResponse.fromJson(responseData);
    } catch (e) {
      if (e is ApiException) {
        if (e.statusCode == 401) {
          return LoginResponse(
            success: false,
            message: 'Invalid email or password',
          );
        } else if (e.statusCode == 400) {
          return LoginResponse(
            success: false,
            message: 'Please check your input and try again',
          );
        } else {
          return LoginResponse(success: false, message: e.message);
        }
      } else {
        return LoginResponse(
          success: false,
          message: 'An unexpected error occurred. Please try again.',
        );
      }
    }
  }

  // Generic GET request method (for future use)
  Future<Map<String, dynamic>> _get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParams);
      final requestHeaders = {'Content-Type': 'application/json', ...?headers};

      final response = await _client
          .get(url, headers: requestHeaders)
          .timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Method to add authorization header for authenticated requests
  Map<String, String> _getAuthHeaders(String? token) {
    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  // Example of authenticated request (for future use)
  Future<Map<String, dynamic>> getUserProfile(String token) async {
    return await _get('/user/profile', headers: _getAuthHeaders(token));
  }

  // Clean up resources
  void dispose() {
    _client.close();
  }
}

// Singleton instance for easy access throughout the app
class ApiService {
  static final ApiClient _client = ApiClient();

  static Future<LoginResponse> login(String email, String password) {
    return _client.login(email, password);
  }

  static void dispose() {
    _client.dispose();
  }
}
