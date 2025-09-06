import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme/theme_bloc.dart';
import 'theme/theme_event.dart';
import 'locale/locale_bloc.dart';
import 'locale/locale_event.dart';
import '../../features/counter/bloc/counter_bloc.dart';
import '../../features/books/bloc/books_bloc.dart';

class AppBlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc()..add(ThemeLoaded()),
    ),
    BlocProvider<LocaleBloc>(
      create: (context) => LocaleBloc()..add(LocaleLoaded()),
    ),
    BlocProvider<BooksBloc>(
      create: (context) => BooksBloc(),
    ),
    BlocProvider<CounterBloc>(
      create: (context) => CounterBloc(),
    ),
  ];
}