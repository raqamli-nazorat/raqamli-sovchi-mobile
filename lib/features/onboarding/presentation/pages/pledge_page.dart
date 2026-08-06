import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/auth/presentation/widgets/auth_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/pledge_item.dart';

final class PledgePage extends StatefulWidget {
  const PledgePage({super.key});

  @override
  State<PledgePage> createState() => _PledgePageState();
}

final class _PledgePageState extends State<PledgePage> {
  bool _acceptedTerms = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
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
              Text(l10n.pledgeTitle, style: AppTypography.onboardingTitle),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.mutedSurface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Column(
                  children: [
                    PledgeItem(text: l10n.pledgePointOne),
                    const SizedBox(height: AppSpacing.md),
                    PledgeItem(text: l10n.pledgePointTwo),
                    const SizedBox(height: AppSpacing.md),
                    PledgeItem(text: l10n.pledgePointThree),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Semantics(
                checked: _acceptedTerms,
                label: l10n.pledgeAgreement,
                child: InkWell(
                  onTap: isLoading
                      ? null
                      : () => setState(() => _acceptedTerms = !_acceptedTerms),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _acceptedTerms
                              ? AppColors.primary
                              : Colors.white,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: _acceptedTerms
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            l10n.pledgeAgreement,
                            style: AppTypography.body.copyWith(
                              fontSize: 13,
                              height: 21 / 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (authState.failure != null) ...[
                Text(
                  l10n.failureMessage(authState.failure!.type.name),
                  style: AppTypography.caption.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              AuthPrimaryButton(
                label: l10n.pledgeStart,
                enabled: _acceptedTerms && !isLoading,
                isLoading: isLoading,
                onPressed: () => context.read<AuthBloc>().add(
                  AuthPledgeSubmitted(
                    acceptedTerms: _acceptedTerms,
                    hasSeriousBadge: _acceptedTerms,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
