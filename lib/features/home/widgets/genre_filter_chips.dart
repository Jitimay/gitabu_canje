import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_config.dart';
import '../../books/bloc/books_bloc.dart';
import '../../books/bloc/books_event.dart';
import '../../books/bloc/books_state.dart';

class GenreFilterChips extends StatelessWidget {
  const GenreFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConfig.bookGenres.length + 1, // +1 for "All" chip
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" chip
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: state.currentGenre == null,
                    onSelected: (selected) {
                      if (selected) {
                        context.read<BooksBloc>().add(const BooksLoadRequested(
                          genre: null,
                          page: 1,
                        ));
                      }
                    },
                  ),
                );
              }

              final genre = AppConfig.bookGenres[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(genre),
                  selected: state.currentGenre == genre,
                  onSelected: (selected) {
                    context.read<BooksBloc>().add(BooksLoadRequested(
                      genre: selected ? genre : null,
                      page: 1,
                    ));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}