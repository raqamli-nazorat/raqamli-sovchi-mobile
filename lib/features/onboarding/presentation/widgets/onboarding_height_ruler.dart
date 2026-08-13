import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingHeightRuler extends StatefulWidget {
  const OnboardingHeightRuler({
    required this.height,
    required this.unit,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onChanged,
    super.key,
  });

  final int height;
  final String unit;
  final String decreaseLabel;
  final String increaseLabel;
  final ValueChanged<int> onChanged;

  @override
  State<OnboardingHeightRuler> createState() => _OnboardingHeightRulerState();
}

final class _OnboardingHeightRulerState extends State<OnboardingHeightRuler> {
  static const _minimumHeight = 100;
  static const _maximumHeight = 300;
  static const _tickExtent = 7.0;
  static const _tickCount = _maximumHeight - _minimumHeight + 1;

  late final ScrollController _scrollController;
  bool _isProgrammaticScroll = false;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _offsetForHeight(widget.height),
    );
  }

  @override
  void didUpdateWidget(covariant OnboardingHeightRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.height == widget.height ||
        !_scrollController.hasClients ||
        _isUserScrolling) {
      return;
    }
    _scrollToHeight(widget.height);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _offsetForHeight(int height) {
    final normalized = height.clamp(_minimumHeight, _maximumHeight);
    return (normalized - _minimumHeight) * _tickExtent;
  }

  int _heightForOffset(double offset) {
    final value = _minimumHeight + (offset / _tickExtent).round();
    return value.clamp(_minimumHeight, _maximumHeight);
  }

  void _scrollToHeight(int height) {
    _isProgrammaticScroll = true;
    _scrollController
        .animateTo(
          _offsetForHeight(height),
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
        )
        .whenComplete(() => _isProgrammaticScroll = false);
  }

  bool _onScroll(ScrollNotification notification) {
    if (_isProgrammaticScroll) return false;
    if (notification is ScrollStartNotification) {
      _isUserScrolling = true;
      return false;
    }
    if (notification is ScrollEndNotification) {
      _isUserScrolling = false;
      final nextHeight = _heightForOffset(_scrollController.offset);
      if (nextHeight != widget.height) {
        widget.onChanged(nextHeight);
      }
      _scrollToHeight(nextHeight);
      return false;
    }
    if (notification is! ScrollUpdateNotification &&
        notification is! UserScrollNotification) {
      return false;
    }
    final nextHeight = _heightForOffset(_scrollController.offset);
    if (nextHeight != widget.height) {
      widget.onChanged(nextHeight);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height.clamp(_minimumHeight, _maximumHeight);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HeightStepButton(
                  icon: Icons.remove,
                  label: widget.decreaseLabel,
                  onPressed: height <= _minimumHeight
                      ? null
                      : () => widget.onChanged(height - 1),
                ),
                const SizedBox(width: AppSpacing.lg + AppSpacing.sm - 2),
                _HeightValueBox(height: height, unit: widget.unit),
                const SizedBox(width: AppSpacing.lg + AppSpacing.sm - 2),
                _HeightStepButton(
                  icon: Icons.add,
                  label: widget.increaseLabel,
                  onPressed: height >= _maximumHeight
                      ? null
                      : () => widget.onChanged(height + 1),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg + 2),
            SizedBox(
              width: 300,
              height: 36,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = (constraints.maxWidth - 2) / 2;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: _onScroll,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          itemExtent: _tickExtent,
                          itemCount: _tickCount,
                          itemBuilder: (context, index) {
                            final height = _minimumHeight + index;
                            return Center(
                              child: _HeightTick(
                                height: height % 5 == 0 ? 22 : 14,
                                color: AppColors.border,
                              ),
                            );
                          },
                        ),
                      ),
                      const IgnorePointer(
                        child: _HeightTick(
                          height: 34,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _HeightStepButton extends StatelessWidget {
  const _HeightStepButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      enabled: onPressed != null,
      child: Material(
        color: AppColors.mutedSurface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 44,
            child: Icon(icon, color: AppColors.text, size: 24),
          ),
        ),
      ),
    );
  }
}

final class _HeightValueBox extends StatelessWidget {
  const _HeightValueBox({required this.height, required this.unit});

  final int height;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('$height', style: AppTypography.onboardingNumeric),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              unit,
              style: AppTypography.onboardingChip.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _HeightTick extends StatelessWidget {
  const _HeightTick({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
