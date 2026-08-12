import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

const _photoGridMaxSlots = 5;

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
    this.showRemoveButton = true,
    this.showMainBadge = false,
    this.mainBadgeLabel = '',
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
  final bool showRemoveButton;
  final bool showMainBadge;
  final String mainBadgeLabel;

  @override
  Widget build(BuildContext context) {
    final sortedPhotos = [...photos]
      ..sort((a, b) => a.order.compareTo(b.order));
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.inline;
        final slotWidth = ((constraints.maxWidth - gap * 2) / 3)
            .clamp(84.0, 104.0)
            .toDouble();
        final slotHeight = slotWidth * 140 / 104;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var row = 0; row < 2; row++) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (
                    var column = 0;
                    column < (row == 0 ? 3 : 2);
                    column++
                  ) ...[
                    if (column > 0) const SizedBox(width: gap),
                    SizedBox(
                      width: slotWidth,
                      height: slotHeight,
                      child: _PhotoSlot(
                        photo: _photoAt(
                          sortedPhotos,
                          row == 0 ? column : column + 3,
                        ),
                        addLabel: addLabel,
                        removeLabel: removeLabel,
                        retryLabel: retryLabel,
                        filledLabelBuilder: filledLabelBuilder,
                        onAdd: onAdd,
                        onRemove: onRemove,
                        onRetry: onRetry,
                        onMainSelected: onMainSelected,
                        showActions: showActions,
                        showRemoveButton: showRemoveButton,
                        showMainBadge: showMainBadge,
                        mainBadgeLabel: mainBadgeLabel,
                      ),
                    ),
                  ],
                ],
              ),
              if (row == 0) const SizedBox(height: gap),
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
    if (index >= _photoGridMaxSlots) return null;
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
    required this.showRemoveButton,
    required this.showMainBadge,
    required this.mainBadgeLabel,
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
  final bool showRemoveButton;
  final bool showMainBadge;
  final String mainBadgeLabel;

  @override
  Widget build(BuildContext context) {
    final currentPhoto = photo;
    if (currentPhoto == null) {
      return _DashedBorder(
        color: AppColors.border,
        child: Material(
          color: AppColors.subtleSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.mutedText, size: 22),
                const SizedBox(height: AppSpacing.xs + 2),
                Text(
                  addLabel,
                  textAlign: TextAlign.center,
                  style: AppTypography.onboardingSelectorLabel.copyWith(
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
            border: showMainBadge && currentPhoto.isMain
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
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
              if (showActions && showRemoveButton)
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: Semantics(
                    button: true,
                    label: removeLabel,
                    child: GestureDetector(
                      onTap: uploading
                          ? null
                          : () => onRemove(currentPhoto.localFilePath),
                      child: Icon(
                        Icons.cancel_rounded,
                        color: uploading
                            ? AppColors.mutedText
                            : AppColors.danger,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              if (showMainBadge && currentPhoto.isMain)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 58,
                  child: Align(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 3,
                        ),
                        child: Text(
                          mainBadgeLabel,
                          textAlign: TextAlign.center,
                          style: AppTypography.onboardingFieldLabel.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            height: 14 / 10,
                            letterSpacing: 0.8,
                          ),
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
