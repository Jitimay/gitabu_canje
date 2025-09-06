import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../books/bloc/books_bloc.dart';
import '../../books/bloc/books_state.dart';
import '../../books/bloc/books_event.dart';

class UpcomingMessagesBanner extends StatelessWidget {
  const UpcomingMessagesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        final activeMessages = state.activeMessages;
        
        if (activeMessages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: activeMessages.map((message) {
              return Card(
                color: Colors.blue.withValues(alpha: 0.1),
                child: ListTile(
                  leading: const Icon(Icons.announcement, color: Colors.blue),
                  title: Text(
                    message.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(message.message),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // TODO: Mark message as dismissed
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
