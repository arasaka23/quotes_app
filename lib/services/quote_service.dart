import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final service = GetIt.instance;

class QuoteService {
  // Основной метод (с категорией)
  Future<List<String>> fetchQuotes({String category = 'success'}) async {
    try {
      List<String> quotesList = [];
      for (int i = 0; i < 5; i++) {
        final response = await service<Dio>().get(
          '/quotes?X-Api-Key=0sDliKqJmO0jWnfKKCePlN9SIFt7NiQyU1Ac8EMw&category=$category',
        );
        final List<dynamic> data = response.data as List<dynamic>;
        final map = data[0] as Map<String, dynamic>;
        quotesList.add('"${map['quote']}"\n— ${map['author']}');
      }
      return quotesList;
    } on DioException catch (e) {
      // Если ошибка 400 (категория недоступна) - пробуем БЕЗ категории
      if (e.response?.statusCode == 400) {
        print('Категория "$category" недоступна на бесплатном тарифе. Грузим без фильтра...');
        return await fetchQuotesWithoutCategory();
      }
      print('Ошибка API: ${e.message}');
      return [];
    }
  }

  // Запасной метод: грузим просто случайные цитаты (без фильтра)
  Future<List<String>> fetchQuotesWithoutCategory() async {
    try {
      List<String> quotesList = [];
      for (int i = 0; i < 5; i++) {
        final response = await service<Dio>().get(
          '/quotes?X-Api-Key=0sDliKqJmO0jWnfKKCePlN9SIFt7NiQyU1Ac8EMw',
        );
        final List<dynamic> data = response.data as List<dynamic>;
        final map = data[0] as Map<String, dynamic>;
        quotesList.add('"${map['quote']}"\n— ${map['author']}');
      }
      return quotesList;
    } catch (e) {
      return [];
    }
  }

  // Метод для одной случайной цитаты (с категорией)
  Future<String> fetchSingleQuote({String category = 'success'}) async {
    try {
      final response = await service<Dio>().get(
        '/quotes?X-Api-Key=0sDliKqJmO0jWnfKKCePlN9SIFt7NiQyU1Ac8EMw&category=$category',
      );
      final List<dynamic> data = response.data as List<dynamic>;
      final map = data[0] as Map<String, dynamic>;
      return '"${map['quote']}"\n— ${map['author']}';
    } on DioException catch (e) {
      // Если категория недоступна — грузим без фильтра
      if (e.response?.statusCode == 400) {
        final response = await service<Dio>().get(
          '/quotes?X-Api-Key=0sDliKqJmO0jWnfKKCePlN9SIFt7NiQyU1Ac8EMw',
        );
        final List<dynamic> data = response.data as List<dynamic>;
        final map = data[0] as Map<String, dynamic>;
        return '"${map['quote']}"\n— ${map['author']}';
      }
      rethrow;
    }
  }
}