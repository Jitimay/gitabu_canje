import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/bloc/theme/theme_event.dart';
import '../../../core/bloc/theme/theme_state.dart';
import '../../../core/bloc/locale/locale_bloc.dart';
import '../../../core/bloc/locale/locale_event.dart';
import '../../../core/bloc/locale/locale_state.dart';
import '../../../core/config/app_config.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            title: const Text('System'),
                            value: ThemeMode.system,
                            groupValue: state.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                context.read<ThemeBloc>().add(ThemeChanged(value));
                              }
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: const Text('Light'),
                            value: ThemeMode.light,
                            groupValue: state.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                context.read<ThemeBloc>().add(ThemeChanged(value));
                              }
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: const Text('Dark'),
                            value: ThemeMode.dark,
                            groupValue: state.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                context.read<ThemeBloc>().add(ThemeChanged(value));
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Language Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<LocaleBloc, LocaleState>(
                    builder: (context, state) {
                      return Column(
                        children: AppConfig.supportedLocales.map((locale) {
                          String displayName;
                          switch (locale.languageCode) {
                            case 'en':
                              displayName = 'English';
                              break;
                            case 'fr':
                              displayName = 'Français';
                              break;
                            case 'rn':
                              displayName = 'Kirundi';
                              break;
                            default:
                              displayName = locale.languageCode;
                          }
                          
                          return RadioListTile<Locale>(
                            title: Text(displayName),
                            value: locale,
                            groupValue: state.locale,
                            onChanged: (value) {
                              if (value != null) {
                                context.read<LocaleBloc>().add(LocaleChanged(value));
                              }
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Theme Toggle
          Card(
            child: ListTile(
              title: const Text('Quick Theme Toggle'),
              subtitle: const Text('Toggle between light and dark theme'),
              trailing: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return Switch(
                    value: state.isDarkMode,
                    onChanged: (_) {
                      context.read<ThemeBloc>().add(ThemeToggled());
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}