import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'update_checker.dart';

class ShorebirdUpdateChecker extends UpdateChecker {
  ShorebirdUpdateChecker(super.refresh);

  final shorebirdCodePush = ShorebirdCodePush();

  @override
  Future checkForUpdates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    hasUpdateFailed = prefs.getBool(UpdateChecker.hasUpdateFailedKey) ?? false;

    if (hasUpdateFailed) {
      return silentUpdate();
    }

    try {
      checkCount++;
      if (hasUpdates) {
        final updated = await shorebirdCodePush.isNewPatchReadyToInstall();
        if (updated) {
          readyToInstall = true;
          refresh();
          return;
        }
      }

      hasUpdates = await shorebirdCodePush.isNewPatchAvailableForDownload();
      refresh();
      if (hasUpdates) {
        await shorebirdCodePush.downloadUpdateIfAvailable();
        readyToInstall = await shorebirdCodePush.isNewPatchReadyToInstall();
        refresh();
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      if (checkCount < 5) {
        await checkForUpdates();
      } else {
        prefs.setBool(UpdateChecker.hasUpdateFailedKey, true);
        hasUpdates = false;
        readyToInstall = false;
        refresh();
      }
    }
  }

  // silentUpdate
  Future silentUpdate() async {
    try {
      final mHasUpdates =
          await shorebirdCodePush.isNewPatchAvailableForDownload();
      if (mHasUpdates) {
        await shorebirdCodePush.downloadUpdateIfAvailable();
        readyToInstall = await shorebirdCodePush.isNewPatchReadyToInstall();
        refresh();
      }
    } catch (e) {
      hasUpdates = false;
      readyToInstall = false;
      refresh();
    }
  }
}
