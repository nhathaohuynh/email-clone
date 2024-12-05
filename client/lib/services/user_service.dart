import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService {
  final String baseUrl;

  // Constructor
  UserApiService(this.baseUrl);

  // Fetch all users
  Future<List<dynamic>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching users: $error');
    }
  }

  // Fetch a single user by ID
  Future<Map<String, dynamic>> fetchUserById(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching user: $error');
    }
  }

  // Create a new user
  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> userData) async {
    final url = Uri.parse(baseUrl); // Ensure baseUrl includes the endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse and return the response body as a Map
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to create user: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error creating user: $error');
      return null;
    }
  }

  // Authenticate user
  Future<Map<String, dynamic>?> signInUser(Map<String, dynamic> userData) async {
    final url = Uri.parse(baseUrl); // Ensure baseUrl includes the endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      return jsonDecode(response.body) as Map<String, dynamic>;

    } catch (error) {
      print('Error sign in user: $error');
      return null;
    }
  }

  // Update user details
  Future<Map<String, dynamic>> updateUser(int userId, Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error updating user: $error');
    }
  }

  // Delete a user
  Future<void> deleteUser(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error deleting user: $error');
    }
  }
}
