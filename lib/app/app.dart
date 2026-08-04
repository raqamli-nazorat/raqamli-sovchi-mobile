import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:thunder/thunder.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({required this.authBloc, super.key});

  final AuthBloc authBloc;

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> with WidgetsBindingObserver {
  late final RouterConfig<Object> _router = AppRouter(
    authBloc: widget.authBloc,
  ).router;
  bool _wasPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _wasPaused = true;
      return;
    }

    if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      widget.authBloc.add(const AuthApplicationResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
        builder: (context, child) => Thunder(
          dio: [serviceLocator<Dio>()],
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
