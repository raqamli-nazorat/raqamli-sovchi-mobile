import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

final class AuthBackButton extends StatelessWidget {
  const AuthBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: Assets.icons.icArrowLeft01Round.svg(width: 20, height: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
    );
  }
}
