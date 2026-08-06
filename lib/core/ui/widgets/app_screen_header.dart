import 'package:flutter/material.dart';

import '../../../app/theme/app_typography.dart';

final class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.pageTitle,
          ),
        ),
        ?trailing,
      ],
    );
  }
}
