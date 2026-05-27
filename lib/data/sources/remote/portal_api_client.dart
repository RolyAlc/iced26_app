import 'dart:convert';

import 'package:dio/dio.dart';

/// Cliente HTTP mínimo para los endpoints públicos del portal.
class PortalApiClient {
  const PortalApiClient(this._dio);

  final Dio _dio;

  Future<String?> fetchLastUpdated() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/sync-status',
      options: Options(
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 404) {
      return null;
    }

    final data = response.data;
    if (data == null) {
      throw StateError('Portal sync-status returned no payload.');
    }

    final lastUpdated = data['last_updated'];
    if (lastUpdated == null) {
      return null;
    }

    if (lastUpdated is! String || lastUpdated.isEmpty) {
      throw StateError('Portal sync-status returned an invalid last_updated.');
    }

    return lastUpdated;
  }

  Future<String> fetchScheduleJson() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/schedule',
      options: Options(receiveTimeout: const Duration(seconds: 30)),
    );

    final data = response.data;
    if (response.statusCode != 200 || data == null) {
      throw StateError('Portal schedule returned no payload.');
    }

    return jsonEncode(data);
  }
}
