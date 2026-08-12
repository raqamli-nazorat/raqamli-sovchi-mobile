import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingVoiceRecorder extends StatefulWidget {
  const OnboardingVoiceRecorder({
    required this.isRecording,
    required this.hasRecording,
    required this.recordLabel,
    required this.playLabel,
    required this.hint,
    required this.onRecordPressed,
    required this.onPlayPressed,
    super.key,
  });

  final bool isRecording;
  final bool hasRecording;
  final String recordLabel;
  final String playLabel;
  final String hint;
  final VoidCallback onRecordPressed;
  final VoidCallback? onPlayPressed;

  @override
  State<OnboardingVoiceRecorder> createState() =>
      _OnboardingVoiceRecorderState();
}

final class _OnboardingVoiceRecorderState extends State<OnboardingVoiceRecorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isRecording) _controller.repeat();
  }

  @override
  void didUpdateWidget(OnboardingVoiceRecorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRecording && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: SizedBox.square(
            dimension: 88,
            child: FilledButton(
              onPressed: widget.onRecordPressed,
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Icon(
                widget.isRecording
                    ? Icons.stop_rounded
                    : Icons.mic_none_rounded,
                size: 34,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.recordLabel,
          textAlign: TextAlign.center,
          style: AppTypography.onboardingAction.copyWith(
            color: AppColors.bodyText,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _AnimatedWaveform(controller: _controller, active: widget.isRecording),
        if (widget.hasRecording) ...[
          const SizedBox(height: AppSpacing.lg),
          TextButton.icon(
            onPressed: widget.onPlayPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(widget.playLabel),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            widget.hint,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingBody,
          ),
        ),
      ],
    );
  }
}

final class _AnimatedWaveform extends StatelessWidget {
  const _AnimatedWaveform({required this.controller, required this.active});

  static const _bars = <double>[
    8,
    26.8,
    31.37,
    18.26,
    18.62,
    31.46,
    26.55,
    8.4,
    27.05,
    31.28,
    17.89,
    18.98,
    31.54,
    26.29,
    8.81,
    27.29,
    31.18,
    17.52,
    19.34,
    31.62,
    26.02,
    9.21,
    27.53,
    31.07,
    17.15,
    19.69,
    31.69,
    25.76,
  ];

  final AnimationController controller;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(300.0, constraints.maxWidth);
        return Center(
          child: SizedBox(
            width: width,
            height: 34,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var index = 0; index < _bars.length; index++)
                      _WaveBar(height: _barHeight(index), active: active),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  double _barHeight(int index) {
    if (!active) return _bars[index] * 0.68;
    final wave = math.sin((controller.value * math.pi * 2) + index * 0.55);
    final scale = 0.78 + (wave + 1) * 0.18;
    return (_bars[index] * scale).clamp(8.0, 34.0);
  }
}

final class _WaveBar extends StatelessWidget {
  const _WaveBar({required this.height, required this.active});

  final double height;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
