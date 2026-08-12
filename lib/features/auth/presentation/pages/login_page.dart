import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/ui/input_formatters/uz_phone_input_formatter.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_social_button.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String get _phoneNumber {
    return UzPhoneInputFormatter.normalizedPhone(_phoneController.text);
  }

  int get _phoneDigitsLength {
    return UzPhoneInputFormatter.localDigits(_phoneController.text).length;
  }

  void _submitPhone(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(AuthPhoneSubmitted(_phoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              final isTelegramPending =
                  state.status == AuthStatus.telegramPending;
              final isInvalid = state.failure?.type == FailureType.validation;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthLogo(),
                    const SizedBox(height: AppSpacing.sm),
                    Text(l10n.loginHeadline, style: AppTypography.pageTitle),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.loginSubtitle,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.phoneLabel,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _phoneController,
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onSubmitted: _phoneDigitsLength == 9
                          ? (_) => _submitPhone(context)
                          : null,
                      inputFormatters: const [UzPhoneInputFormatter()],
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '90 123 45 67',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.placeholder,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Center(
                          widthFactor: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.lg,
                              right: AppSpacing.md,
                            ),
                            child: Text(
                              '+998',
                              style: AppTypography.body.copyWith(
                                color: AppColors.placeholder,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        errorText: isInvalid ? l10n.phoneError : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AuthPrimaryButton(
                      label: l10n.continueLabel,
                      isLoading: isLoading,
                      enabled: _phoneDigitsLength == 9,
                      onPressed: () => _submitPhone(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            l10n.orLabel,
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        AuthSocialButton(
                          label: 'Telegram',
                          icon: Assets.icons.icTelegramIcon,
                          onPressed: isLoading || isTelegramPending
                              ? null
                              : () => context.read<AuthBloc>().add(
                                  const AuthTelegramSignInRequested(),
                                ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        AuthSocialButton(
                          label: 'Google',
                          icon: Assets.icons.icGoogleIcon,
                          onPressed: isLoading || isTelegramPending
                              ? null
                              : () => context.read<AuthBloc>().add(
                                  const AuthGoogleSignInRequested(),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Assets.icons.icInfo.svg(width: 15, height: 15),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.loginNote,
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              height: 17 / 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isTelegramPending) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(l10n.telegramWaiting, style: AppTypography.caption),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () => context.read<AuthBloc>().add(
                          const AuthFlowCancelled(),
                        ),
                        child: Text(l10n.retry),
                      ),
                    ],
                    if (state.failure != null &&
                        !isInvalid &&
                        state.failure!.type != FailureType.cancelled) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.failureMessage(state.failure!.type.name),
                        style: AppTypography.caption.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
