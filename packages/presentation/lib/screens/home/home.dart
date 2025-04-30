// packages/presentation/lib/screens/home/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/screens/auth/store/auth_store.dart';
import 'package:presentation/screens/navigation_service.dart';
import 'package:presentation/screens/post/post_list.dart';
import 'package:presentation/store/language/language_state.dart';
import 'package:presentation/store/language/language_store.dart';
import 'package:presentation/store/theme/theme_state.dart';
import 'package:presentation/store/theme/theme_store.dart';
import 'package:presentation/utils/locale/app_localization.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class HomeScreen extends StatefulWidget {
  final NavigationService navigationService;
  const HomeScreen({super.key, required this.navigationService});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static Widget create() {
    return HomeScreen(navigationService: GetIt.instance<NavigationService>());
  }
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final LanguageStore _languageStore = getIt<LanguageStore>();
  final AuthStore _authCubit = getIt<AuthStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PostListScreen(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_tv_posts')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
      _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return BlocBuilder<ThemeStore, ThemeState>(
      bloc: _themeStore,
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            _themeStore.toggleDarkMode();
          },
          icon: Icon(
            state.isDarkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        _authCubit.logout();
        widget.navigationService.goToLogin();
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: BlocBuilder<ThemeStore, ThemeState>(
        bloc: _themeStore,
        builder: (context, themeState) {
          return BlocBuilder<LanguageStore, LanguageState>(
            bloc: _languageStore,
            builder: (context, languageState) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('home_tv_choose_language'),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                actions: languageState.supportedLocales
                    .map(
                      (locale) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.all(0.0),
                        title: Text(
                          locale.displayName,
                          style: TextStyle(
                            color: languageState.languageCode ==
                                    locale.languageCode
                                ? Theme.of(context).primaryColor
                                : themeState.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          // change user language based on selected locale
                          _languageStore.changeLocale(locale);
                        },
                      ),
                    )
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
