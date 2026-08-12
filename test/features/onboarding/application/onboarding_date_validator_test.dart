import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/onboarding/application/onboarding_date_validator.dart';

void main() {
  test('accepts exact age limits including leap-year birthdays', () {
    final now = DateTime(2026, 2, 28);

    expect(
      OnboardingDateValidator.isEligible(DateTime(2008, 2, 28), now),
      isTrue,
    );
    expect(
      OnboardingDateValidator.isEligible(DateTime(1966, 2, 28), now),
      isTrue,
    );
    expect(
      OnboardingDateValidator.isEligible(DateTime(2008, 2, 29), now),
      isFalse,
    );
    expect(
      OnboardingDateValidator.isEligible(
        DateTime(2008, 2, 29),
        DateTime(2026, 3, 1),
      ),
      isTrue,
    );
    expect(
      OnboardingDateValidator.isEligible(DateTime(2008, 3, 1), now),
      isFalse,
    );
    expect(
      OnboardingDateValidator.isEligible(DateTime(1965, 2, 27), now),
      isFalse,
    );
  });
}
