import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

final class AppFilterPill extends StatelessWidget {
  const AppFilterPill({required this.label, this.selected = false, super.key});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.surfaceLight : const Color(0xFF525252),
          ),
        ),
      ),
    );
  }
}
