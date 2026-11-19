import 'package:flutter/material.dart';
import '../services/quote_service.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  final _quoteService = QuoteService();
  List<String> _quotes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() => _isLoading = true);
    final quotes = await _quoteService.fetchQuotes();
    setState(() {
      _quotes = quotes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadQuotes,
            child: ListView.builder(
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.format_quote, color: Colors.deepPurple, size: 30),
                    title: Text(
                      _quotes[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.4, // Межстрочный интервал для красоты
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}