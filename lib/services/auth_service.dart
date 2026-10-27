import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
      );
}

class AuthService {
  // Base URLs to test (10.0.2.2 for Android Emulator, localhost for Windows/Web)
  static String customUrl = 'http://10.0.2.2/students_tasks_tracker_api';

  static List<String> get possibleBaseUrls => [
        customUrl,
        'http://10.0.2.2/students_tasks_tracker_api',
        'http://localhost/students_tasks_tracker_api',
        'http://127.0.0.1/students_tasks_tracker_api',
      ];

  static final ValueNotifier<UserModel?> currentUserNotifier =
      ValueNotifier<UserModel?>(
    UserModel(
      id: '1',
      name: 'Sir William',
      email: 'SirWilliam@gmail.com',
    ),
  );

  static UserModel? get currentUser => currentUserNotifier.value;

  static Future<void> initSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user_session');
      if (userStr != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(userStr);
        currentUserNotifier.value = UserModel.fromJson(jsonMap);
      }
    } catch (_) {}
  }

  static Future<void> saveSession(UserModel user) async {
    currentUserNotifier.value = user;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_session', jsonEncode(user.toJson()));
    } catch (_) {}
  }

  static Future<void> clearSession() async {
    currentUserNotifier.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_session');
    } catch (_) {}
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return {
        'success': false,
        'message': 'Please enter both email and password.'
      };
    }

    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return {
        'success': false,
        'message': 'Please enter a valid email address.'
      };
    }

    // Try posting to XAMPP API endpoints
    String? lastError;
    for (String url in possibleBaseUrls) {
      try {
        final response = await http
            .post(
              Uri.parse('$url/login.php'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': cleanEmail,
                'password': cleanPassword,
              }),
            )
            .timeout(const Duration(seconds: 4));

        if (kDebugMode) {
          print('XAMPP Login [$url] status: ${response.statusCode}, body: ${response.body}');
        }

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            final user = UserModel.fromJson(data['user']);
            await saveSession(user);
            return {'success': true, 'user': user};
          } else {
            return {
              'success': false,
              'message': data['message'] ?? 'Invalid email or password.'
            };
          }
        }
      } catch (e) {
        lastError = e.toString();
      }
    }

    // Fallback: If XAMPP backend is not running, check default sample
    if (cleanEmail.toLowerCase() == 'sirwilliam@gmail.com' && cleanPassword.isNotEmpty) {
      final user = UserModel(
        id: '1',
        name: 'Sir William',
        email: cleanEmail,
      );
      await saveSession(user);
      return {'success': true, 'user': user};
    }

    return {
      'success': false,
      'message':
          'Could not connect to XAMPP database server. Error: ${lastError ?? "Connection refused"}. Please check XAMPP Apache & MySQL.'
    };
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    if (cleanName.isEmpty || cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return {
        'success': false,
        'message': 'Full Name, Email, and Password are all required.'
      };
    }

    // Name & Surname Check (at least two words)
    final nameParts = cleanName.split(RegExp(r'\s+'));
    if (nameParts.length < 2) {
      return {
        'success': false,
        'message':
            'Please enter both your First Name and Surname (e.g. "John Doe").'
      };
    }

    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return {
        'success': false,
        'message': 'Please enter a valid email address.'
      };
    }

    if (cleanPassword.length < 6) {
      return {
        'success': false,
        'message': 'Password must be at least 6 characters long.'
      };
    }

    // Attempt XAMPP HTTP API Register across possible base URLs
    String? lastError;
    for (String url in possibleBaseUrls) {
      try {
        final response = await http
            .post(
              Uri.parse('$url/register.php'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'name': cleanName,
                'email': cleanEmail,
                'password': cleanPassword,
              }),
            )
            .timeout(const Duration(seconds: 4));

        if (kDebugMode) {
          print('XAMPP Register [$url] status: ${response.statusCode}, body: ${response.body}');
        }

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            final user = UserModel.fromJson(data['user']);
            await saveSession(user);
            return {'success': true, 'user': user};
          } else {
            return {
              'success': false,
              'message': data['message'] ?? 'Registration failed in database.'
            };
          }
        }
      } catch (e) {
        lastError = e.toString();
      }
    }

    return {
      'success': false,
      'message':
          'Could not connect to XAMPP database server. Error: ${lastError ?? "Connection failed"}. Make sure Apache & MySQL are running in XAMPP.'
    };
  }
}
