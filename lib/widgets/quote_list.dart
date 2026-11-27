import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/quote_cubit.dart';

class QuoteList extends StatelessWidget {
  const QuoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuoteCubit, QuoteState>(
      listener: (context, state) {
        if (state is QuoteSingleSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Случайная цитата'),
              content: Text(state.quote),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is QuoteLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuoteError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        } else if (state is QuoteSuccess) {
          return RefreshIndicator(
            onRefresh: () => context.read<QuoteCubit>().fetchQuotes(),
            child: ListView.builder(
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.format_quote, color: Colors.deepPurple),
                    title: Text(state.quotes[index], style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Нажмите кнопку для загрузки'));
      },
    );
  }
}