import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';

final class AuthCodeCells extends StatelessWidget {
  const AuthCodeCells({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 4; index++) ...[
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: index < value.length
                      ? AppColors.primary
                      : AppColors.border,
                  width: index < value.length ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(
                  index < value.length ? value[index] : '',
                  style: AppTypography.body.copyWith(
                    fontSize: 22,
                    height: 28 / 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ),
          if (index != 3) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
