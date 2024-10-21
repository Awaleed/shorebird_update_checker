class UpdateCheckerConfig {
  final bool enableIos;
  final bool enableAndroid;

  final bool enableAppStoreUpdateChecker;
  final bool enableShorebirdUpdateChecker;

  final bool forceAppStoreUpdate;
  final bool forceShorebirdUpdate;

  final String? androidAppId;
  final String? iOSAppId;

  const UpdateCheckerConfig({
    this.enableIos = true,
    this.enableAndroid = true,
    this.iOSAppId,
    this.androidAppId,
    this.enableAppStoreUpdateChecker = true,
    this.enableShorebirdUpdateChecker = true,
    this.forceAppStoreUpdate = false,
    this.forceShorebirdUpdate = false,
  });
}
