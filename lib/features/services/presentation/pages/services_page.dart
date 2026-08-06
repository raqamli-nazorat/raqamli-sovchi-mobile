import 'package:flutter/material.dart';

import '../../../../core/ui/widgets/app_tab_placeholder.dart';
import '../../../../l10n/app_localizations.dart';

final class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabPlaceholder(
      title: l10n.servicesTabLabel,
      message: l10n.servicesPlaceholder,
    );
  }
}
