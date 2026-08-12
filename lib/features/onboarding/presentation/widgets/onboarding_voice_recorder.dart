import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingVoiceRecorder extends StatefulWidget {
  const OnboardingVoiceRecorder({
    required this.isRecording,
    required this.isPlaying,
    required this.hasRecording,
    required this.recordLabel,
    required this.playLabel,
    required this.reRecordLabel,
    required this.deleteLabel,
    required this.hint,
    required this.recordingHint,
    required this.recordingDuration,
    required this.onRecordPressed,
    required this.onPlayPressed,
    required this.onRewritePressed,
    required this.onDeletePressed,
    super.key,
  });

  final bool isRecording;
  final bool isPlaying;
  final bool hasRecording;
  final String recordLabel;
  final String playLabel;
  final String reRecordLabel;
  final String deleteLabel;
  final String hint;
  final String recordingHint;
  final String recordingDuration;
  final VoidCallback onRecordPressed;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onRewritePressed;
  final VoidCallback? onDeletePressed;

  @override
  State<OnboardingVoiceRecorder> createState() =>
      _OnboardingVoiceRecorderState();
}

final class _OnboardingVoiceRecorderState extends State<OnboardingVoiceRecorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _animated => widget.isRecording || widget.isPlaying;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (_animated) _controller.repeat();
  }

  @override
  void didUpdateWidget(OnboardingVoiceRecorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_animated && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!_animated && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasRecording && !widget.isRecording) {
      return _RecordedVoice(
        isPlaying: widget.isPlaying,
        duration: widget.recordingDuration,
        playLabel: widget.playLabel,
        reRecordLabel: widget.reRecordLabel,
        deleteLabel: widget.deleteLabel,
        hint: widget.recordingHint,
        controller: _controller,
        onPlayPressed: widget.onPlayPressed,
        onRewritePressed: widget.onRewritePressed,
        onDeletePressed: widget.onDeletePressed,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Semantics(
            button: true,
            label: widget.recordLabel,
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
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.recordLabel,
          textAlign: TextAlign.center,
          style: AppTypography.onboardingAction.copyWith(
            color: AppColors.bodyText,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _AnimatedWaveform(
          controller: _controller,
          active: widget.isRecording,
          recorded: false,
        ),
        const SizedBox(height: AppSpacing.lg),
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

final class _RecordedVoice extends StatelessWidget {
  const _RecordedVoice({
    required this.isPlaying,
    required this.duration,
    required this.playLabel,
    required this.reRecordLabel,
    required this.deleteLabel,
    required this.hint,
    required this.controller,
    required this.onPlayPressed,
    required this.onRewritePressed,
    required this.onDeletePressed,
  });

  final bool isPlaying;
  final String duration;
  final String playLabel;
  final String reRecordLabel;
  final String deleteLabel;
  final String hint;
  final AnimationController controller;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onRewritePressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: BoxDecoration(
            color: AppColors.mutedSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Semantics(
                button: true,
                label: playLabel,
                child: SizedBox.square(
                  dimension: 48,
                  child: FilledButton(
                    onPressed: onPlayPressed,
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _AnimatedWaveform(
                  controller: controller,
                  active: isPlaying,
                  recorded: true,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                duration,
                style: AppTypography.onboardingFieldLabel.copyWith(
                  color: AppColors.bodyText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: reRecordLabel,
                onPressed: onRewritePressed,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                label: deleteLabel,
                destructive: true,
                onPressed: onDeletePressed,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(hint, style: AppTypography.onboardingBody),
        ),
      ],
    );
  }
}

final class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: destructive ? Colors.white : AppColors.text,
          backgroundColor: destructive ? AppColors.danger : Colors.white,
          side: BorderSide(
            color: destructive ? AppColors.danger : AppColors.border,
          ),
          shape: const StadiumBorder(),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Text(label),
      ),
    );
  }
}

final class _AnimatedWaveform extends StatelessWidget {
  const _AnimatedWaveform({
    required this.controller,
    required this.active,
    required this.recorded,
  });

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
  final bool recorded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final progress = recorded && active
              ? (controller.value * (_bars.length + 5)).floor()
              : recorded
              ? 11
              : _bars.length;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var index = 0; index < _bars.length; index++)
                _WaveBar(
                  height: _barHeight(index),
                  color: recorded && index >= progress
                      ? const Color(0xFFA3A3A3)
                      : active || recorded
                      ? AppColors.primary
                      : AppColors.border,
                ),
            ],
          );
        },
      ),
    );
  }

  double _barHeight(int index) {
    if (!active) return _bars[index].clamp(8, 34);
    final wave = math.sin((controller.value * math.pi * 2) + index * 0.55);
    final scale = 0.78 + (wave + 1) * 0.18;
    return (_bars[index] * scale).clamp(8.0, 34.0);
  }
}

final class _WaveBar extends StatelessWidget {
  const _WaveBar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
