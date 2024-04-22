import 'package:dio/dio.dart';
import 'package:frontend/main.dart';

class MonkException {
  static Future<T> handle<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (e) {
      logger.e('API ERROR: status: ${e.response?.statusCode}',
          error: e.message ?? e.error);
      if (e.response?.statusCode == 500) {
        throw Exception("Internal Server Error");
      }
      if (e.response != null && e.response?.data != null) {
        final rawData = e.response?.data as Map<String, dynamic>;
        if (e.response?.statusCode == 404) {
          if (rawData['message'] != null) {
            throw Exception(rawData['message']);
          }
          throw Exception(e.toString());
        }
      }
      throw Exception(e.toString());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
