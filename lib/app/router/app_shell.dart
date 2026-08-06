import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/widgets/app_bottom_nav_bar.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

final class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onItemSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          AppBottomNavItem(
            label: l10n.candidatesTabLabel,
            icon: Assets.icons.icCandidatesBtv,
          ),
          AppBottomNavItem(
            label: l10n.messagesTabLabel,
            icon: Assets.icons.icMessagesBtv,
          ),
          AppBottomNavItem(
            label: l10n.servicesTabLabel,
            icon: Assets.icons.icServicesBtv,
          ),
          AppBottomNavItem(
            label: l10n.savedTabLabel,
            icon: Assets.icons.icPreservedBtv,
          ),
          AppBottomNavItem(
            label: l10n.profileTabLabel,
            icon: Assets.icons.icProfileBtv,
          ),
        ],
      ),
    );
  }
}
