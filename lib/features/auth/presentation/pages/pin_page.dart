import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_keypad.dart';
import '../widgets/auth_primary_button.dart';

enum PinPageMode { create, unlock }

final class PinPage extends StatefulWidget {
  const PinPage({required this.mode, super.key});

  final PinPageMode mode;

  @override
  State<PinPage> createState() => _PinPageState();
}

final class _PinPageState extends State<PinPage> {
  String _value = '';
  bool _requestedBiometricAvailability = false;
  bool _requestedBiometricUnlock = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.mode == PinPageMode.unlock && !_requestedBiometricAvailability) {
      _requestedBiometricAvailability = true;
      context.read<AuthBloc>().add(const AuthBiometricAvailabilityRequested());
    }
  }

  void _requestBiometricUnlockIfReady(AuthState authState) {
    if (widget.mode != PinPageMode.unlock ||
        _requestedBiometricUnlock ||
        !authState.biometricAvailable ||
        authState.status != AuthStatus.pinLocked) {
      return;
    }
    _requestedBiometricUnlock = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthBloc>().add(const AuthBiometricUnlockRequested());
    });
  }

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
    _requestBiometricUnlockIfReady(authState);
    final isCreate = widget.mode == PinPageMode.create;
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
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AuthBackButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthFlowCancelled());
                    context.go(isCreate ? RouteNames.login : RouteNames.login);
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          isCreate ? l10n.pinHintCreate : l10n.pinHintUnlock,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          isCreate ? l10n.pinCreateTitle : l10n.pinUnlockTitle,
                          style: AppTypography.pinTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var index = 0; index < 4; index++) ...[
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < _value.length
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              if (index != 3) const SizedBox(width: 14),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AuthKeypad(
                          onDigit: _addDigit,
                          onBackspace: _removeDigit,
                          showFingerprint:
                              !isCreate && authState.biometricAvailable,
                          onFingerprint: () => context.read<AuthBloc>().add(
                            const AuthBiometricUnlockRequested(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AuthPrimaryButton(
                          label: isCreate
                              ? l10n.continueLabel
                              : l10n.unlockLabel,
                          enabled: _value.length == 4,
                          isLoading: isLoading,
                          onPressed: () => context.read<AuthBloc>().add(
                            isCreate
                                ? AuthPinCreated(_value)
                                : AuthPinUnlockRequested(_value),
                          ),
                        ),
                        if (authState.failure != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.failureMessage(authState.failure!.type.name),
                            style: AppTypography.caption.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
