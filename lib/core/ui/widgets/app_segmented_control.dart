import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

final class AppSegmentedControl extends StatelessWidget {
  const AppSegmentedControl({
    required this.labels,
    required this.selectedIndex,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (var index = 0; index < labels.length; index++)
              Expanded(
                child: _SegmentItem(
                  label: labels[index],
                  selected: index == selectedIndex,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _SegmentItem extends StatelessWidget {
  const _SegmentItem({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceLight : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 5),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.text : AppColors.mutedText,
          ),
        ),
      ),
    );
  }
}
