import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:upgrader/upgrader.dart';

class MandatoryUpdateGate extends StatelessWidget {
  const MandatoryUpdateGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        durationUntilAlertAgain: Duration.zero,
        debugLogging: kDebugMode,
      ),
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: false,
      shouldPopScope: () => false,
      child: child,
    );
  }
}
