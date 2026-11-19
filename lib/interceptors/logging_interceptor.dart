import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Добавляем твой API ключ в заголовки
    options.headers['X-Api-Key'] = '0sDliKqJmO0jWnfKKCePlN9SIFt7NiQyU1Ac8EMw';
    
    print('--> REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('<-- RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('<-- ERROR[${err.message}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}