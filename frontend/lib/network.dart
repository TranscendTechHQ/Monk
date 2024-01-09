import 'package:dio/dio.dart';
import 'constants.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:openapi/openapi.dart';

class NetworkManager {
  // Step 1: Define a private constructor
  NetworkManager._();

  // Step 2: Create a static private instance variable
  static NetworkManager? _instance;

  // Step 3: Create a static getter method
  static NetworkManager get instance {
    // If the instance doesn't exist, create a new one
    if (_instance == null) {
      _instance = NetworkManager._();
      _instance!._initClient();
    }
    return _instance!;
  }

  late Dio client;
  List<Interceptor> interceptors() {
    return [
      SuperTokensInterceptorWrapper(client: client),
    ];
  }

  late Openapi openApi;

  void _initClient() {
    client = Dio(BaseOptions(
      baseUrl: apiDomain,
    ));
    //client.addSupertokensInterceptor();
    client.interceptors
        .add(SuperTokensInterceptorWrapper(client: client)); //same as above
    openApi = Openapi(
      dio: client,
      basePathOverride: apiDomain,
      interceptors: interceptors(),
    );
  }
}
