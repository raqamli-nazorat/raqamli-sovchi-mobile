import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_primary_button.dart';
import '../../domain/entities/candidate_type.dart';
import '../widgets/candidate_type_card.dart';

final class CandidateTypePage extends StatefulWidget {
  const CandidateTypePage({super.key});

  @override
  State<CandidateTypePage> createState() => _CandidateTypePageState();
}

final class _CandidateTypePageState extends State<CandidateTypePage> {
  CandidateType _selected = CandidateType.groom;

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
              Text(
                l10n.candidateTypeTitle,
                style: AppTypography.onboardingTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.candidateTypeSubtitle,
                style: AppTypography.body.copyWith(
                  fontSize: 13,
                  height: 21 / 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF737373),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              CandidateTypeCard(
                title: l10n.groomCandidateTitle,
                subtitle: l10n.groomCandidateSubtitle,
                selected: _selected == CandidateType.groom,
                onTap: () => setState(() => _selected = CandidateType.groom),
              ),
              const SizedBox(height: AppSpacing.md),
              CandidateTypeCard(
                title: l10n.brideCandidateTitle,
                subtitle: l10n.brideCandidateSubtitle,
                selected: _selected == CandidateType.bride,
                onTap: () => setState(() => _selected = CandidateType.bride),
              ),
              const SizedBox(height: AppSpacing.md),
              CandidateTypeCard(
                title: l10n.representativeCandidateTitle,
                subtitle: l10n.representativeCandidateSubtitle,
                selected: _selected == CandidateType.representative,
                onTap: () =>
                    setState(() => _selected = CandidateType.representative),
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
                label: l10n.continueLabel,
                enabled: !isLoading,
                isLoading: isLoading,
                onPressed: () => context.read<AuthBloc>().add(
                  AuthCandidateTypeSelected(_selected),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
