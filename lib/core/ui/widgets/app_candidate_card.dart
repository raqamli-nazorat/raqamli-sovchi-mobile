import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../gen/assets.gen.dart';

final class AppCandidateCardData {
  const AppCandidateCardData({
    required this.nameAge,
    required this.city,
    required this.matchPercent,
    required this.image,
  });

  final String nameAge;
  final String city;
  final String matchPercent;
  final AssetGenImage image;
}

final class AppCandidateCard extends StatelessWidget {
  const AppCandidateCard({
    required this.candidate,
    required this.privatePhotoLabel,
    super.key,
  });

  final AppCandidateCardData candidate;
  final String privatePhotoLabel;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 165 / 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Transform.scale(
                      scale: 1.18,
                      child: candidate.image.image(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  Center(child: _PrivatePhotoPill(label: privatePhotoLabel)),
                  const Positioned(top: 8, right: 8, child: _VerifiedBadge()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            candidate.nameAge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              height: 19 / 14,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Flexible(
                child: Text(
                  '${candidate.city} ·',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    height: 17 / 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                candidate.matchPercent,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  height: 15 / 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _PrivatePhotoPill extends StatelessWidget {
  const _PrivatePhotoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.text,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.icGlyph.svg(
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(
                AppColors.surfaceLight,
                BlendMode.srcIn,
              ),
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.surfaceLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 22,
        height: 22,
        child: Center(
          child: Assets.icons.icVerifyCheck.svg(
            width: 13,
            height: 13,
            colorFilter: const ColorFilter.mode(
              AppColors.surfaceLight,
              BlendMode.srcIn,
            ),
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
