import 'package:dio/dio.dart';
import 'package:frontend/helper/either.dart';
import 'package:frontend/main.dart';

typedef ResultOrException<T> = Future<Either<DioException, T>>;
typedef FutureCallback<ResultOrException> = Future<ResultOrException>
    Function();

class AsyncRequest {
  static ResultOrException<T> handle<T>(FutureCallback callback) async {
    try {
      final result = await callback();
      return Right(result);
    } on DioException catch (e) {
      logger.e('API ERROR: status: ${e.response?.statusCode}',
          error: e.message ?? e.error);
      if (e.response?.statusCode == 500) {
        // throw Exception("Internal Server Error");
        return Left(e);
      }
      if (e.response != null && e.response?.data != null) {
        final rawData = e.response?.data as Map<String, dynamic>;
        if (e.response?.statusCode == 404) {
          if (rawData['message'] != null) {
            // throw Exception(rawData['message']);
          }
          // throw Exception(e.toString());
        }
      }
      // throw Exception(e.toString());
      return Left(e);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
