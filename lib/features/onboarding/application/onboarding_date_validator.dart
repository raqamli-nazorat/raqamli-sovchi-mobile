final class OnboardingDateValidator {
  const OnboardingDateValidator._();

  static bool isEligible(DateTime birthDate, DateTime now) {
    final date = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final today = DateTime(now.year, now.month, now.day);
    var age = today.year - date.year;
    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      age--;
    }
    return age >= 18 && age <= 60;
  }
}
