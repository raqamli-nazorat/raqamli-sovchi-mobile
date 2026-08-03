import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:raqamli_sovchi/features/auth/presentation/widgets/auth_code_cells.dart';
import 'package:raqamli_sovchi/features/auth/presentation/widgets/auth_primary_button.dart';

void main() {
  testWidgets('OTP cells render entered digits and empty cells', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AuthCodeCells(value: '123')),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.byType(AuthCodeCells), findsOneWidget);
  });

  testWidgets('auth button disables itself until enabled', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthPrimaryButton(
            label: 'Continue',
            enabled: false,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    expect(pressed, isFalse);
  });
}
