import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

final class OnboardingPhotoSelector extends StatelessWidget {
  const OnboardingPhotoSelector({
    required this.photos,
    required this.onSelected,
    super.key,
  });

  final List<OnboardingPhotoDraft> photos;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final sorted = [...photos]..sort((a, b) => a.order.compareTo(b.order));
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          for (var index = 0; index < sorted.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            Expanded(
              child: _PhotoTile(photo: sorted[index], onSelected: onSelected),
            ),
          ],
        ],
      ),
    );
  }
}

final class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo, required this.onSelected});

  final OnboardingPhotoDraft photo;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final hasLocal = File(photo.localFilePath).existsSync();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: photo.serverId == null
            ? null
            : () => onSelected(photo.serverId!),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: photo.isMain ? AppColors.primary : AppColors.border,
              width: photo.isMain ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasLocal)
                Image.file(File(photo.localFilePath), fit: BoxFit.cover)
              else if (photo.imageUrl?.isNotEmpty == true)
                Image.network(photo.imageUrl!, fit: BoxFit.cover),
              if (photo.isMain)
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
