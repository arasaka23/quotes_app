import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/quote_service.dart';

abstract class QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteSuccess extends QuoteState {
  final List<String> quotes;
  QuoteSuccess(this.quotes);
}

class QuoteError extends QuoteState {
  final String message;
  QuoteError(this.message);
}

class QuoteSingleSuccess extends QuoteState {
  final String quote;
  QuoteSingleSuccess(this.quote);
}

class QuoteCubit extends Cubit<QuoteState> {
  final QuoteService _quoteService;
  String _currentCategory = 'success'; // Категория по умолчанию

  QuoteCubit(this._quoteService) : super(QuoteLoading());

  String get currentCategory => _currentCategory;

  Future<void> fetchQuotes() async {
    emit(QuoteLoading());
    try {
      final quotes = await _quoteService.fetchQuotes(category: _currentCategory);
      if (quotes.isEmpty) {
        emit(QuoteError('Не удалось загрузить цитаты'));
      } else {
        emit(QuoteSuccess(quotes));
      }
    } catch (e) {
      emit(QuoteError('Ошибка: $e'));
    }
  }

  Future<void> fetchSingleQuote() async {
    emit(QuoteLoading());
    try {
      final quote = await _quoteService.fetchSingleQuote(category: _currentCategory);
      emit(QuoteSingleSuccess(quote));
    } catch (e) {
      emit(QuoteError('Ошибка: $e'));
    }
  }

  // Метод для смены категории
  void setCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;
      fetchQuotes(); // Сразу перезагружаем цитаты
    }
  }
}