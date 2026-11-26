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

class QuoteCubit extends Cubit<QuoteState> {
  final QuoteService _quoteService;

  QuoteCubit(this._quoteService) : super(QuoteLoading());

  Future<void> fetchQuotes() async {
    emit(QuoteLoading()); 
    
    try {
      final quotes = await _quoteService.fetchQuotes();
      
      if (quotes.isEmpty) {
        emit(QuoteError('Не удалось загрузить цитаты')); 
        emit(QuoteSuccess(quotes)); 
      }
    } catch (e) {
      emit(QuoteError('Произошла ошибка: $e')); 
    }
  }
}