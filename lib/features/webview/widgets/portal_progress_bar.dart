import 'package:flutter/material.dart';

import '../../../core/app_constants.dart';

class PortalProgressBar extends StatelessWidget {
  const PortalProgressBar({
    required this.progress,
    required this.hidden,
    super.key,
  });

  final int progress;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox.shrink();

    return LinearProgressIndicator(
      value: progress == 0 ? null : progress / 100,
      minHeight: 3,
      color: AppConstants.brandColor,
      backgroundColor: const Color(0xFFEAD8E0),
    );
  }
}
