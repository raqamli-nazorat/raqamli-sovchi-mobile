import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingHeightWeightInput extends StatefulWidget {
  const OnboardingHeightWeightInput({
    required this.height,
    required this.weight,
    required this.heightLabel,
    required this.weightLabel,
    required this.heightUnit,
    required this.weightUnit,
    required this.decreaseHeightLabel,
    required this.increaseHeightLabel,
    required this.decreaseWeightLabel,
    required this.increaseWeightLabel,
    required this.onHeightChanged,
    required this.onWeightChanged,
    super.key,
  });

  final int height;
  final int weight;
  final String heightLabel;
  final String weightLabel;
  final String heightUnit;
  final String weightUnit;
  final String decreaseHeightLabel;
  final String increaseHeightLabel;
  final String decreaseWeightLabel;
  final String increaseWeightLabel;
  final ValueChanged<int> onHeightChanged;
  final ValueChanged<int> onWeightChanged;

  @override
  State<OnboardingHeightWeightInput> createState() =>
      _OnboardingHeightWeightInputState();
}

final class _OnboardingHeightWeightInputState
    extends State<OnboardingHeightWeightInput> {
  static const _minHeight = 100;
  static const _maxHeight = 250;
  static const _minWeight = 20;
  static const _maxWeight = 250;

  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: '${widget.height}');
    _weightController = TextEditingController(text: '${widget.weight}');
  }

  @override
  void didUpdateWidget(covariant OnboardingHeightWeightInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController(_heightController, widget.height, oldWidget.height);
    _syncController(_weightController, widget.weight, oldWidget.weight);
  }

  void _syncController(
    TextEditingController controller,
    int value,
    int oldValue,
  ) {
    if (value != oldValue && controller.text == '$oldValue') {
      controller.text = '$value';
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _changeHeight(int value) {
    final next = value.clamp(_minHeight, _maxHeight);
    _heightController.text = '$next';
    _heightController.selection = TextSelection.collapsed(
      offset: _heightController.text.length,
    );
    widget.onHeightChanged(next);
  }

  void _changeWeight(int value) {
    final next = value.clamp(_minWeight, _maxWeight);
    _weightController.text = '$next';
    _weightController.selection = TextSelection.collapsed(
      offset: _weightController.text.length,
    );
    widget.onWeightChanged(next);
  }

  void _handleHeightText(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed >= _minHeight && parsed <= _maxHeight) {
      widget.onHeightChanged(parsed);
    }
  }

  void _handleWeightText(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed >= _minWeight && parsed <= _maxWeight) {
      widget.onWeightChanged(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MeasurementRow(
          label: widget.heightLabel,
          valueController: _heightController,
          unit: widget.heightUnit,
          decreaseLabel: widget.decreaseHeightLabel,
          increaseLabel: widget.increaseHeightLabel,
          canDecrease: widget.height > _minHeight,
          canIncrease: widget.height < _maxHeight,
          onDecrease: () => _changeHeight(widget.height - 1),
          onIncrease: () => _changeHeight(widget.height + 1),
          onChanged: _handleHeightText,
        ),
        const SizedBox(height: AppSpacing.lg),
        _MeasurementRow(
          label: widget.weightLabel,
          valueController: _weightController,
          unit: widget.weightUnit,
          decreaseLabel: widget.decreaseWeightLabel,
          increaseLabel: widget.increaseWeightLabel,
          canDecrease: widget.weight > _minWeight,
          canIncrease: widget.weight < _maxWeight,
          onDecrease: () => _changeWeight(widget.weight - 1),
          onIncrease: () => _changeWeight(widget.weight + 1),
          onChanged: _handleWeightText,
        ),
      ],
    );
  }
}

final class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({
    required this.label,
    required this.valueController,
    required this.unit,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
    required this.onChanged,
  });

  final TextEditingController valueController;
  final String label;
  final String unit;
  final String decreaseLabel;
  final String increaseLabel;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.onboardingSelectorValue.copyWith(
            color: AppColors.bodyText,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StepButton(
              icon: Icons.remove,
              semanticLabel: decreaseLabel,
              enabled: canDecrease,
              onPressed: onDecrease,
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 92,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 46,
                      child: TextField(
                        controller: valueController,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: onChanged,
                        style: AppTypography.onboardingMeasurementValue,
                        decoration: const InputDecoration.collapsed(
                          hintText: '',
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(unit, style: AppTypography.onboardingMeasurementUnit),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _StepButton(
              icon: Icons.add,
              semanticLabel: increaseLabel,
              enabled: canIncrease,
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}

final class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.semanticLabel,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: enabled,
      child: Material(
        color: AppColors.mutedSurface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: 40,
            child: Icon(
              icon,
              color: enabled ? AppColors.text : AppColors.placeholder,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
