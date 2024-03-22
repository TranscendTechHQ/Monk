import 'package:dio/dio.dart';
import 'package:frontend/main.dart';

class MonkException {
  static Future<T> handle<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (e) {
      final rawData = e.response?.data as Map<String, dynamic>;
      if (e.response?.statusCode == 404) {
        if (rawData['message'] != null) {
          throw Exception(rawData['message']);
        }
        throw Exception(e.toString());
      }
      throw Exception(e.toString());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
