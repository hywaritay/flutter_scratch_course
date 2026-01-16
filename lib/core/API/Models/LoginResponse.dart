import 'User.dart';

class LoginResponse {
  final bool success;
  final String? token;
  final String? message;
  final User? user;

  LoginResponse({required this.success, this.token, this.message, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'],
      message: json['message'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}