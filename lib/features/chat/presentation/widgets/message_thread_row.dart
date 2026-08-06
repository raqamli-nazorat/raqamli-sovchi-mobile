import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../gen/assets.gen.dart';

final class MessageThreadData {
  const MessageThreadData({
    required this.name,
    required this.preview,
    required this.time,
    required this.avatar,
    this.unread = false,
  });

  final String name;
  final String preview;
  final String time;
  final AssetGenImage avatar;
  final bool unread;
}

final class MessageThreadRow extends StatelessWidget {
  const MessageThreadRow({required this.thread, super.key});

  final MessageThreadData thread;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mutedSurface)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: Row(
          children: [
            ClipOval(
              child: thread.avatar.image(
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            height: 19 / 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        thread.time,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          height: 17 / 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.placeholder,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    thread.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      height: 19 / 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            if (thread.unread) ...[
              const SizedBox(width: 14),
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(width: 8, height: 8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
