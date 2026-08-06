import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../core/ui/widgets/app_segmented_control.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/message_thread_row.dart';

final class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final threads = _mockThreads(l10n);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                AppScreenHeader(title: l10n.messagesTabLabel),
                const SizedBox(height: AppSpacing.lg),
                AppSegmentedControl(
                  labels: [
                    l10n.messagesSegmentChats,
                    l10n.messagesSegmentRequests,
                  ],
                  selectedIndex: 0,
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverList.builder(
              itemCount: threads.length,
              itemBuilder: (context, index) {
                return MessageThreadRow(thread: threads[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<MessageThreadData> _mockThreads(AppLocalizations l10n) {
    return [
      MessageThreadData(
        name: l10n.mockMessageMohiraName,
        preview: l10n.mockMessageMohiraPreview,
        time: '14:20',
        avatar: Assets.images.image1,
        unread: true,
      ),
      MessageThreadData(
        name: l10n.mockMessageZilolaName,
        preview: l10n.mockMessageZilolaPreview,
        time: l10n.messageTimeYesterday,
        avatar: Assets.images.image2,
      ),
      MessageThreadData(
        name: l10n.mockMessageNilufarName,
        preview: l10n.mockMessageNilufarPreview,
        time: l10n.messageTimeMonday,
        avatar: Assets.images.image3,
      ),
      MessageThreadData(
        name: l10n.mockMessageDilnozaName,
        preview: l10n.mockMessageDilnozaPreview,
        time: l10n.messageTimeTuesday,
        avatar: Assets.images.image4,
      ),
    ];
  }
}
