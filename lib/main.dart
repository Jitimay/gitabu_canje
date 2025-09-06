import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gitabu/features/home/pages/home_page.dart';

import 'core/config/app_config.dart';
import 'core/bloc/app_bloc_providers.dart';
import 'core/bloc/theme/theme_bloc.dart';
import 'core/bloc/theme/theme_state.dart';
import 'core/bloc/locale/locale_bloc.dart';
import 'core/bloc/locale/locale_state.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase initialization failed - app can still run in demo mode
    print('Firebase initialization failed: $e');
  }

  runApp(const IgitabuApp());
}

class IgitabuApp extends StatelessWidget {
  const IgitabuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Igitabu',
                debugShowCheckedModeBanner: false,

                // Theme
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,

                // Localization
                locale: localeState.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppConfig.supportedLocales,

                // Home page
                home: const HomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
