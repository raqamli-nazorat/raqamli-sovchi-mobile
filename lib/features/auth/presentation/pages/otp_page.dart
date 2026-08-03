import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_code_cells.dart';
import '../widgets/auth_keypad.dart';
import '../widgets/auth_primary_button.dart';

final class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

final class _OtpPageState extends State<OtpPage> {
  String _value = '';

  void _addDigit(String digit) {
    if (_value.length >= 4) return;
    setState(() => _value += digit);
  }

  void _removeDigit() {
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final phone = authState.phoneNumber ?? '+998 90 123 45 67';
    final isLoading = authState.status == AuthStatus.loading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthBackButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthFlowCancelled());
                  context.go(RouteNames.login);
                },
              ),
              const Spacer(),
              Text(l10n.otpTitle, style: AppTypography.pageTitle),
              const SizedBox(height: AppSpacing.xl),
              AuthCodeCells(value: _value),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.otpSentTo(phone),
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.otpResend,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              AuthKeypad(onDigit: _addDigit, onBackspace: _removeDigit),
              const SizedBox(height: AppSpacing.xl),
              AuthPrimaryButton(
                label: l10n.confirmLabel,
                enabled: _value.length == 4,
                isLoading: isLoading,
                onPressed: () =>
                    context.read<AuthBloc>().add(AuthOtpSubmitted(_value)),
              ),
              if (authState.failure != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.failureMessage(authState.failure!.type),
                  style: AppTypography.caption.copyWith(color: Colors.red),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.temporaryOtpHint,
                style: AppTypography.caption.copyWith(
                  color: AppColors.placeholder,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
