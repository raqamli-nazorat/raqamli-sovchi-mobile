import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class PledgeItem extends StatelessWidget {
  const PledgeItem({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(Icons.circle, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              fontSize: 13,
              height: 21 / 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF404040),
            ),
          ),
        ),
      ],
    );
  }
}
