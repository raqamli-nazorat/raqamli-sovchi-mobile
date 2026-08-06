import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/pin_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/chat/presentation/pages/messages_page.dart';
import '../../features/discovery/presentation/pages/candidates_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/saved/presentation/pages/saved_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import 'app_shell.dart';
import 'route_names.dart';

final class AppRouter {
  AppRouter({required AuthBloc authBloc})
    : _authBloc = authBloc,
      _refreshListenable = _AuthRouterRefreshListenable(authBloc.stream);

  final AuthBloc _authBloc;
  final _AuthRouterRefreshListenable _refreshListenable;

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _refreshListenable,
    redirect: (context, state) {
      final status = _authBloc.state.status;
      final location = state.matchedLocation;
      final onSplash = location == RouteNames.splash;
      final onLogin = location == RouteNames.login;
      final onOtp = location == RouteNames.otp;
      final onPin =
          location == RouteNames.pinCreate || location == RouteNames.pinUnlock;

      if (status == AuthStatus.initial) {
        return onSplash ? null : RouteNames.splash;
      }

      if (status == AuthStatus.loading) return null;

      if (status == AuthStatus.authenticated) {
        return onSplash || onLogin || onOtp || onPin ? RouteNames.home : null;
      }

      if (status == AuthStatus.otpPending) {
        return onOtp ? null : RouteNames.otp;
      }

      if (status == AuthStatus.telegramPending) {
        return onLogin ? null : RouteNames.login;
      }

      if (status == AuthStatus.pinSetupRequired) {
        return location == RouteNames.pinCreate ? null : RouteNames.pinCreate;
      }

      if (status == AuthStatus.pinLocked) {
        return location == RouteNames.pinUnlock ? null : RouteNames.pinUnlock;
      }

      return onLogin ? null : RouteNames.login;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) => const OtpPage(),
      ),
      GoRoute(
        path: RouteNames.pinCreate,
        builder: (context, state) => const PinPage(mode: PinPageMode.create),
      ),
      GoRoute(
        path: RouteNames.pinUnlock,
        builder: (context, state) => const PinPage(mode: PinPageMode.unlock),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const CandidatesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.messages,
                builder: (context, state) => const MessagesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.services,
                builder: (context, state) => const ServicesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.saved,
                builder: (context, state) => const SavedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

final class _AuthRouterRefreshListenable extends ChangeNotifier {
  _AuthRouterRefreshListenable(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
