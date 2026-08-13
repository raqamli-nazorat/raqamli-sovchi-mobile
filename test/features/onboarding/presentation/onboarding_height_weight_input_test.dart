import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/onboarding_height_weight_input.dart';

void main() {
  testWidgets('height and weight values can be edited with the keyboard', (
    tester,
  ) async {
    var height = 179;
    var weight = 68;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OnboardingHeightWeightInput(
            height: height,
            weight: weight,
            heightLabel: 'Bo‘yingiz',
            weightLabel: 'Vazningiz',
            heightUnit: 'sm',
            weightUnit: 'kg',
            decreaseHeightLabel: 'Bo‘yni kamaytirish',
            increaseHeightLabel: 'Bo‘yni oshirish',
            decreaseWeightLabel: 'Vaznni kamaytirish',
            increaseWeightLabel: 'Vaznni oshirish',
            onHeightChanged: (value) => height = value,
            onWeightChanged: (value) => weight = value,
          ),
        ),
      ),
    );

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '182');
    await tester.enterText(fields.at(1), '74');

    expect(height, 182);
    expect(weight, 74);
  });
}
