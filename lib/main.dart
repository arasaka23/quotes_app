import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'interceptors/logging_interceptor.dart';
import 'widgets/quote_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupService();
  runApp(const QuoteApp()); 
}

void setupService() {
  GetIt.instance.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api.api-ninjas.com/v1/',
        headers: {'X-Api-Key': '0sDliKqJmO0jWnfKKCePlN9SIFt7NiQyU1Ac8EMw'}, 
      ),
    )..interceptors.addAll([
        LoggingInterceptor(), 
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      ]),
  );
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      theme: ThemeData(primarySwatch: Colors.deepPurple), 
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Мудрые мысли'), 
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const QuoteList(), 
      ),
    );
  }
}