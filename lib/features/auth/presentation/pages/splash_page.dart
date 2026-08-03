import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_logo.dart';

final class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFB9DCFF), AppColors.primary],
            stops: [0, 0.46, 1],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: -40,
              right: -40,
              bottom: -190,
              height: 500,
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'assets/auth/splash_art.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthLogo(onPrimary: true, large: true),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.splashSubtitle,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      height: 21 / 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
