import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_device_apps_app_change_event.dart';

/// Information about an installed app on the device.
///
/// Contains metadata like package name, version, install times, and optional icon data.
class AppInfo {
  /// Creates an [AppInfo] with the specified properties.
  ///
  /// All parameters are optional and represent various pieces of app metadata.
  const AppInfo({
    this.packageName,
    this.appName,
    this.versionName,
    this.versionCode,
    this.uid,
    this.apkPath,
    this.apkSizeBytes,
    this.dataPath,
    this.isOnExternalStorage,
    this.firstInstallTime,
    this.lastUpdateTime,
    this.isSystem,
    this.iconBytes,
    this.category,
    this.targetSdkVersion,
    this.minSdkVersion,
    this.enabled,
    this.processName,
    this.installLocation,
  });

  /// Creates an [AppInfo] from a map of key-value pairs.
  ///
  /// The map typically comes from platform-specific implementations.
  /// Handles type conversion and null safety for various data types.
  factory AppInfo.fromMap(Map<String, Object?> m) {
    final int? firstInstallTime = m['firstInstallTime'] != null
        ? int.tryParse(m['firstInstallTime']!.toString())
        : null;
    final DateTime? firstInstallTimeDate = firstInstallTime != null
        ? DateTime.fromMillisecondsSinceEpoch(firstInstallTime)
        : null;

    final int? lastUpdateTime = m['lastUpdateTime'] != null
        ? int.tryParse(m['lastUpdateTime']!.toString())
        : null;
    final DateTime? lastUpdateTimeDate = lastUpdateTime != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdateTime)
        : null;

    final int? category = m['category'] != null ? int.tryParse(m['category']!.toString()) : null;
    final int? targetSdkVersion = m['targetSdkVersion'] != null
        ? int.tryParse(m['targetSdkVersion']!.toString())
        : null;
    final int? minSdkVersion = m['minSdkVersion'] != null
        ? int.tryParse(m['minSdkVersion']!.toString())
        : null;
    final bool? enabled = m['enabled'] != null ? bool.tryParse(m['enabled']!.toString()) : null;
    final int? installLocation = m['installLocation'] != null
        ? int.tryParse(m['installLocation']!.toString())
        : null;

    return AppInfo(
      packageName: m['packageName']?.toString(),
      appName: m['appName']?.toString(),
      versionName: m['versionName']?.toString(),
      versionCode: m['versionCode'] != null ? int.tryParse(m['versionCode']!.toString()) : null,
      uid: m['uid'] != null ? int.tryParse(m['uid']!.toString()) : null,
      apkPath: m['apkPath']?.toString(),
      apkSizeBytes: m['apkSizeBytes'] != null ? int.tryParse(m['apkSizeBytes']!.toString()) : null,
      dataPath: m['dataPath']?.toString(),
      isOnExternalStorage: m['isOnExternalStorage'] != null
          ? bool.tryParse(m['isOnExternalStorage']!.toString())
          : null,
      firstInstallTime: firstInstallTimeDate,
      lastUpdateTime: lastUpdateTimeDate,
      isSystem: m['isSystem'] != null ? bool.tryParse(m['isSystem']!.toString()) : null,
      iconBytes: m['iconBytes'] is List<int>
          ? Uint8List.fromList(m['iconBytes']! as List<int>)
          : null,
      category: category,
      targetSdkVersion: targetSdkVersion,
      minSdkVersion: minSdkVersion,
      enabled: enabled,
      processName: m['processName']?.toString(),
      installLocation: installLocation,
    );
  }

  /// The unique package name identifier for the app (e.g., 'com.example.app').
  final String? packageName;

  /// The human-readable display name of the app.
  final String? appName;

  /// The version name as displayed to users (e.g., '1.0.0').
  final String? versionName;

  /// The internal version code used for version comparison.
  final int? versionCode;

  /// Linux/kernel-level UID assigned to the app on the device.
  ///
  /// This is not a globally unique or stable business identifier.
  final int? uid;

  /// Full path to the base APK file (Android ApplicationInfo.sourceDir).
  final String? apkPath;

  /// APK size in bytes (base APK + split APK files when present).
  ///
  /// Null when not available.
  final int? apkSizeBytes;

  /// Full path to the app's private data directory (Android ApplicationInfo.dataDir).
  final String? dataPath;

  /// Raw Android flag from ApplicationInfo.FLAG_EXTERNAL_STORAGE.
  final bool? isOnExternalStorage;

  /// The date and time when the app was first installed on the device.
  final DateTime? firstInstallTime;

  /// The date and time when the app was last updated.
  final DateTime? lastUpdateTime;

  /// Whether the app is a system app (preinstalled) or user-installed.
  final bool? isSystem;

  /// The app icon as raw bytes, if requested and available.
  final Uint8List? iconBytes;

  /// App category (Android ApplicationInfo.category, API 26+). Raw int from platform. Null when not set or API < 26.
  final int? category;

  /// Target SDK version (Android ApplicationInfo.targetSdkVersion).
  final int? targetSdkVersion;

  /// Min SDK version (Android ApplicationInfo.minSdkVersion).
  final int? minSdkVersion;

  /// Whether the app is enabled (Android ApplicationInfo.enabled).
  final bool? enabled;

  /// Process name (Android ApplicationInfo.processName).
  final String? processName;

  /// Install location (Android PackageInfo.installLocation).
  final int? installLocation;
}

/// Information about how an app was installed.
class AppInstallSourceInfo {
  /// Creates installation source information with optional platform metadata.
  const AppInstallSourceInfo({
    this.installingPackageName,
    this.initiatingPackageName,
    this.originatingPackageName,
    this.packageSource,
    this.updateOwnerPackageName,
  });

  /// Creates installation source information from a platform map.
  factory AppInstallSourceInfo.fromMap(Map<String, Object?> m) => AppInstallSourceInfo(
    installingPackageName: m['installingPackageName']?.toString(),
    initiatingPackageName: m['initiatingPackageName']?.toString(),
    originatingPackageName: m['originatingPackageName']?.toString(),
    packageSource: m['packageSource'] != null ? int.tryParse(m['packageSource']!.toString()) : null,
    updateOwnerPackageName: m['updateOwnerPackageName']?.toString(),
  );

  /// The installer of record, or null when unavailable.
  ///
  /// This value can be changed after installation. Null does not establish
  /// whether an app was sideloaded.
  final String? installingPackageName;

  /// The package that requested installation (Android API 30+).
  final String? initiatingPackageName;

  /// The package on whose behalf installation was requested (Android API 30+).
  ///
  /// Supplied by the installer and not verified by Android. Access is restricted
  /// by Android permissions, so this value is usually null for ordinary apps.
  final String? originatingPackageName;

  /// Raw Android PackageInstaller.PACKAGE_SOURCE_* value (API 33+).
  ///
  /// Null on older Android versions. Zero means the source is unspecified.
  final int? packageSource;

  /// The package owning updates (Android API 34+), or null when unavailable.
  final String? updateOwnerPackageName;
}

/// Base class every platform implementation must extend.
abstract class FlutterDeviceAppsPlatform extends PlatformInterface {
  /// Creates a [FlutterDeviceAppsPlatform] with the provided [token].
  ///
  /// Platform implementations should pass [_token] to verify authenticity.
  FlutterDeviceAppsPlatform({super.token = _token});
  static const Object _token = Object();

  static FlutterDeviceAppsPlatform _instance = _UnimplementedPlatform();

  /// The current platform implementation instance.
  ///
  /// Defaults to [_UnimplementedPlatform] which throws errors if no real
  /// implementation is registered via [instance] setter.
  static FlutterDeviceAppsPlatform get instance => _instance;

  /// Platform implementations must call this to register themselves.
  static set instance(FlutterDeviceAppsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Lists installed apps.
  Future<List<AppInfo>> listApps({
    bool includeSystem = false,
    bool onlyLaunchable = true,
    bool includeIcons = false,
  });

  /// Gets details for a single app.
  Future<AppInfo?> getApp(String packageName, {bool includeIcon = false});

  /// Gets the app icon as PNG bytes without loading the full app metadata.
  ///
  /// Returns null when the package is missing, not visible, or its icon resources
  /// cannot be loaded. Returns Android's default icon if no icon is defined.
  Future<Uint8List?> getAppIcon(String packageName);

  /// Whether [packageName] is installed and visible to the calling app.
  ///
  /// Includes disabled apps and apps without a launcher entry. Returns false
  /// when the package is missing or hidden by Android package visibility rules.
  Future<bool> isAppInstalled(String packageName);

  /// Whether [packageName] is a system app, using the same flag as [AppInfo.isSystem].
  ///
  /// Returns null when the package is missing or hidden by Android package
  /// visibility rules. Includes disabled apps and apps without a launcher entry.
  Future<bool?> isSystemApp(String packageName);

  /// Gets the requested permissions for a specific app.
  ///
  /// Implementations should return the Android PackageInfo.requestedPermissions
  /// list for the given [packageName], or null if not available.
  Future<List<String>?> getRequestedPermissions(String packageName);

  /// Best-effort: launches an app by package name. Returns false if not launchable.
  Future<bool> openApp(String packageName);

  /// Stream of app change events (install, uninstall, update).
  ///
  /// Platform implementations should emit [AppChangeEvent] objects when apps
  /// are installed, removed, or updated on the device.
  ///
  /// The stream automatically starts listening when the first subscriber is added
  /// and stops when all subscribers are removed (broadcast stream behavior).
  Stream<AppChangeEvent> get appChanges;

  /// Opens the app settings for the specified package name.
  ///
  /// Platform implementations should open the app settings page for the given package.
  /// Returns true if the settings page was successfully opened, false otherwise.
  Future<bool> openAppSettings(String packageName);

  /// Uninstalls the app with the specified package name.
  ///
  /// Platform implementations should uninstall the app with the given package name.
  /// Returns true if the app was successfully uninstalled, false otherwise.
  Future<bool> uninstallApp(String packageName);

  /// Gets installation source information without loading full app metadata.
  ///
  /// Returns null when the package is missing or not visible. On Android before
  /// API 30, only installingPackageName is available. A returned model can have
  /// null fields when Android does not provide the corresponding information.
  Future<AppInstallSourceInfo?> getInstallSourceInfo(String packageName);

  /// Gets the installer store for the specified package name.
  ///
  /// Platform implementations should return the installer store for the given package.
  /// Returns the installer store name or null if not available.
  // Newly deprecated; retain the method for backwards compatibility.
  @Deprecated('Use getInstallSourceInfo() and its installingPackageName instead.')
  Future<String?> getInstallerStore(String packageName);
}

/// Default no-op implementation to throw if no platform is registered.
class _UnimplementedPlatform extends FlutterDeviceAppsPlatform {
  _UnimplementedPlatform() : super();

  @override
  Future<List<AppInfo>> listApps({
    bool includeSystem = false,
    bool onlyLaunchable = true,
    bool includeIcons = false,
  }) => Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<AppInfo?> getApp(String packageName, {bool includeIcon = false}) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<Uint8List?> getAppIcon(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> isAppInstalled(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool?> isSystemApp(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<List<String>?> getRequestedPermissions(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> openApp(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Stream<AppChangeEvent> get appChanges =>
      Stream.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> openAppSettings(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> uninstallApp(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<AppInstallSourceInfo?> getInstallSourceInfo(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  // Newly deprecated; retain the method for backwards compatibility.
  @Deprecated('Use getInstallSourceInfo() and its installingPackageName instead.')
  Future<String?> getInstallerStore(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));
}
