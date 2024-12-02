import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../errors/exceptions.dart';
import 'package:logger/logger.dart';
import 'package:bloc/bloc.dart';

part 'http_handler_state.dart';

class HttpHandler extends Cubit<HttpHandlerState> {
  final http.Client client;
  final Logger logger;
  String? _token;

  HttpHandler({required this.client, String? token})
      : logger = Logger(),
        super(HttpHandlerInitial()) {
    _token = token;
  }

  Future<Map<String, dynamic>> get(String url,
      {Map<String, String>? headers}) async {
    await _ensureToken();

    try {
      logger.i('HTTP GET Request: $url');
      final response = await client.get(
        Uri.parse(url),
        headers: _addAuthHeader(headers),
      );

      final responseBody = json.decode(response.body);
      logger.i('HTTP Response Status: ${response.statusCode}');
      logger.d('Response Body: $responseBody');

      if (response.statusCode == 200 && !responseBody['error']) {
        return responseBody;
      } else {
        throw ServerException(responseBody['message'] ?? 'Unknown error');
      }
    } catch (e) {
      logger.e('Failed to connect to the server: $e');
      throw ServerException('Failed to connect to the server: $e');
    }
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      logger.i('HTTP POST Request: $url');
      logger.d('Request Body: $body');
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _addAuthHeader(headers),
      );

      final responseBody = json.decode(response.body);
      logger.i('HTTP Response Status: ${response.statusCode}');
      logger.d('Response Body: $responseBody');

      if (response.statusCode == 200 && !responseBody['error']) {
        return responseBody;
      } else {
        throw ServerException(responseBody['message'] ?? 'Unknown error');
      }
    } catch (e) {
      logger.e('Failed to connect to the server: $e');
      throw ServerException('Failed to connect to the server: $e');
    }
  }

  Map<String, String> _addAuthHeader(Map<String, String>? headers) {
    final Map<String, String> authHeaders = headers ?? {};
    if (_token != null) {
      authHeaders['Authorization'] = 'Bearer $_token';
    }
    authHeaders['Content-Type'] = 'application/json';
    return authHeaders;
  }

  void setToken(String? token) {
    _token = token;
    emit(HttpHandlerTokenSet(token));
  }

  void clearToken() {
    _token = null;
    emit(HttpHandlerTokenCleared());
  }

  Future<void> _ensureToken() async {
    if (_token == null) {
      logger.i('Token not available. Attempting to fetch token...');

      // Load token from TokenProvider or SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('token');

      if (storedToken != null) {
        _token = storedToken;
        logger.i('Token loaded from SharedPreferences.');
      } else {
        logger.e('Token is still null after attempt to load.');
        throw ServerException('Token not available for authenticated request.');
      }
    }
  }

  Future<Map<String, dynamic>> postx(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    RequestType type = RequestType.public,
    String? token,
  }) async {
    try {
      // Prepare headers
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
      };

      // Handle token based on request type
      switch (type) {
        case RequestType.public:
          // No token needed, use existing or empty headers
          requestHeaders.addAll(headers ?? {});
          break;

        case RequestType.protected:
          // Token is mandatory
          await _ensureToken();
          if (token == null) {
            throw ServerException(
                'Authentication token is required for protected routes');
          }
          requestHeaders['Authorization'] = 'Bearer $token';
          requestHeaders.addAll(headers ?? {});
          break;

        case RequestType.optional:
          // Token is optional
          if (token != null) {
            requestHeaders['Authorization'] = 'Bearer $token';
          }
          requestHeaders.addAll(headers ?? {});
          break;
      }

      // Log request details
      logger.i('HTTP POST Request: $url');
      logger.d('Request Type: $type');
      logger.d('Request Headers: $requestHeaders');
      logger.d('Request Body: $body');

      // Perform the POST request
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: requestHeaders,
      );

      // Parse response
      final responseBody = json.decode(response.body);
      logger.i('HTTP Response Status: ${response.statusCode}');
      logger.d('Response Body: $responseBody');

      // Handle response
      if (response.statusCode == 200 && !responseBody['error']) {
        return responseBody;
      } else {
        throw ServerException(responseBody['message'] ?? 'Unknown error');
      }
    } catch (e) {
      logger.e('Failed to connect to the server: $e');
      throw ServerException('Failed to connect to the server: $e');
    }
  }
}

enum RequestType {
  public, // No authentication required
  protected, // Requires authentication token
  optional // Can have token, but not mandatory
}


// // 1. Public route (no authentication)
// await post(
//   'https://api.example.com/public-endpoint', 
//   {'data': 'some_public_data'},
//   type: RequestType.public
// );

// // 2. Protected route (token mandatory)
// await post(
//   'https://api.example.com/protected-endpoint', 
//   {'sensitive': 'data'},
//   type: RequestType.protected,
//   token: 'your_access_token'
// );

// // 3. Optional route (token can be added but not required)
// await post(
//   'https://api.example.com/optional-endpoint', 
//   {'data': 'some_data'},
//   type: RequestType.optional,
//   token: 'your_access_token' // Optional
// );

// // 4. Public route with additional headers
// await post(
//   'https://api.example.com/another-public-endpoint', 
//   {'data': 'some_data'},
//   type: RequestType.public,
//   headers: {'X-Custom-Header': 'value'}
// );