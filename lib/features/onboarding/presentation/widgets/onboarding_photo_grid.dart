import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

final class OnboardingPhotoGrid extends StatelessWidget {
  const OnboardingPhotoGrid({
    required this.photos,
    required this.addLabel,
    required this.removeLabel,
    required this.retryLabel,
    required this.filledLabelBuilder,
    required this.onAdd,
    required this.onRemove,
    required this.onRetry,
    this.onMainSelected,
    this.showActions = true,
    super.key,
  });

  final List<OnboardingPhotoDraft> photos;
  final String addLabel;
  final String removeLabel;
  final String retryLabel;
  final String Function(int order) filledLabelBuilder;
  final VoidCallback? onAdd;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRetry;
  final ValueChanged<String>? onMainSelected;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final sortedPhotos = [...photos]
      ..sort((a, b) => a.order.compareTo(b.order));
    return LayoutBuilder(
      builder: (context, constraints) {
        final slotWidth = (constraints.maxWidth - AppSpacing.md) / 2;
        final slotHeight = (slotWidth * 1.28).clamp(164.0, 212.0);
        return Column(
          children: [
            for (var row = 0; row < 2; row++) ...[
              Row(
                children: [
                  for (var column = 0; column < 2; column++) ...[
                    if (column > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SizedBox(
                        height: slotHeight,
                        child: _PhotoSlot(
                          photo: _photoAt(sortedPhotos, row * 2 + column),
                          addLabel: addLabel,
                          removeLabel: removeLabel,
                          retryLabel: retryLabel,
                          filledLabelBuilder: filledLabelBuilder,
                          onAdd: onAdd,
                          onRemove: onRemove,
                          onRetry: onRetry,
                          onMainSelected: onMainSelected,
                          showActions: showActions,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (row == 0) const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }

  OnboardingPhotoDraft? _photoAt(
    List<OnboardingPhotoDraft> sortedPhotos,
    int index,
  ) {
    if (index >= sortedPhotos.length) return null;
    return sortedPhotos[index];
  }
}

final class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.photo,
    required this.addLabel,
    required this.removeLabel,
    required this.retryLabel,
    required this.filledLabelBuilder,
    required this.onAdd,
    required this.onRemove,
    required this.onRetry,
    required this.onMainSelected,
    required this.showActions,
  });

  final OnboardingPhotoDraft? photo;
  final String addLabel;
  final String removeLabel;
  final String retryLabel;
  final String Function(int order) filledLabelBuilder;
  final VoidCallback? onAdd;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRetry;
  final ValueChanged<String>? onMainSelected;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final currentPhoto = photo;
    if (currentPhoto == null) {
      return _DashedBorder(
        color: AppColors.border,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.mutedText, size: 22),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  addLabel,
                  textAlign: TextAlign.center,
                  style: AppTypography.onboardingCardBody.copyWith(
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final failed = currentPhoto.uploadStatus == PhotoUploadStatus.failed;
    final uploading = currentPhoto.uploadStatus == PhotoUploadStatus.uploading;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: currentPhoto.serverId == null || onMainSelected == null
            ? null
            : () => onMainSelected!(currentPhoto.serverId!),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.subtleSurface,
            border: Border.all(
              color: currentPhoto.isMain ? AppColors.primary : AppColors.border,
              width: currentPhoto.isMain ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (File(currentPhoto.localFilePath).existsSync())
                Image.file(File(currentPhoto.localFilePath), fit: BoxFit.cover)
              else if (currentPhoto.imageUrl?.isNotEmpty == true)
                Image.network(currentPhoto.imageUrl!, fit: BoxFit.cover),
              if (uploading)
                const Center(
                  child: SizedBox.square(
                    dimension: AppSpacing.xl,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              if (failed)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onRetry(currentPhoto.localFilePath),
                    ),
                  ),
                ),
              if (showActions)
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: IconButton(
                    tooltip: removeLabel,
                    onPressed: uploading
                        ? null
                        : () => onRemove(currentPhoto.localFilePath),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.text,
                  ),
                ),
              if (currentPhoto.isMain)
                const Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
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

final class _DashedBorder extends StatelessWidget {
  const _DashedBorder({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedBorderPainter(color),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: child,
      ),
    );
  }
}

final class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(0.75),
          const Radius.circular(AppRadius.lg),
        ),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashWidth = 7.0;
      const dashSpace = 5.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
