import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingDateWheelPicker extends StatelessWidget {
  const OnboardingDateWheelPicker({
    required this.value,
    required this.minimumDate,
    required this.maximumDate,
    required this.onChanged,
    super.key,
  });

  final DateTime value;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final days = List<String>.generate(31, (index) => '${index + 1}');
    final months = List<String>.generate(
      12,
      (index) => DateFormat.MMMM(locale).format(DateTime(2000, index + 1)),
    );
    final years = List<String>.generate(
      maximumDate.year - minimumDate.year + 1,
      (index) => '${minimumDate.year + index}',
    );

    return SizedBox(
      height: 208,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.circular(AppRadius.xl - 4),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _DateWheelColumn(
                    values: days,
                    selectedIndex: value.day - 1,
                    onSelected: (index) => onChanged(
                      _safeDate(value.year, value.month, index + 1),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _DateWheelColumn(
                    values: months,
                    selectedIndex: value.month - 1,
                    onSelected: (index) =>
                        onChanged(_safeDate(value.year, index + 1, value.day)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _DateWheelColumn(
                    values: years,
                    selectedIndex: value.year - minimumDate.year,
                    onSelected: (index) => onChanged(
                      _safeDate(
                        minimumDate.year + index,
                        value.month,
                        value.day,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime _safeDate(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    final candidate = DateTime(year, month, day.clamp(1, lastDay).toInt());
    if (candidate.isBefore(minimumDate)) return minimumDate;
    if (candidate.isAfter(maximumDate)) return maximumDate;
    return candidate;
  }
}

final class _DateWheelColumn extends StatefulWidget {
  const _DateWheelColumn({
    required this.values,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> values;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<_DateWheelColumn> createState() => _DateWheelColumnState();
}

final class _DateWheelColumnState extends State<_DateWheelColumn> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(covariant _DateWheelColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex &&
        _controller.hasClients &&
        _controller.selectedItem != widget.selectedIndex) {
      _controller.jumpToItem(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: 40,
      diameterRatio: 100,
      perspective: 0.001,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.onSelected,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.values.length,
        builder: (context, index) {
          final distance = (index - widget.selectedIndex).abs();
          final color = distance == 0
              ? AppColors.text
              : AppColors.mutedText.withValues(
                  alpha: distance == 1 ? 0.45 : 0.2,
                );
          return Center(
            child: Text(
              widget.values[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.onboardingWheel.copyWith(color: color),
            ),
          );
        },
      ),
    );
  }
}
