import 'package:flutter/material.dart';

final class AuthBackButton extends StatelessWidget {
  const AuthBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: Image.asset('assets/auth/back.png', width: 20, height: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
    );
  }
}
