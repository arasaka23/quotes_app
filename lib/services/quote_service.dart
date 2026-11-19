import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final service = GetIt.instance;

class QuoteService {
  Future<List<String>> fetchQuotes() async {
    try {
      List<String> quotesList = [];

      for (int i = 0; i < 5; i++) {
        final response = await service<Dio>().get('/quotes');
        
        final List<dynamic> data = response.data as List<dynamic>;
        final map = data[0] as Map<String, dynamic>;
        
        // Склеиваем цитату и автора и добавляем в наш список
        quotesList.add('"${map['quote']}"\n— ${map['author']}');
      }
      
      return quotesList;
          
    } on DioException catch (e) {
      print('Ошибка API: ${e.message}');
      if (e.response != null) {
        print('Статус: ${e.response?.statusCode}');
        print('Тело: ${e.response?.data}');
      }
      return [];
    } catch (e) {
      print('Неожиданная ошибка: $e');
      return [];
    }
  }
}