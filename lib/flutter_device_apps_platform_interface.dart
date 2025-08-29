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
    this.firstInstallTime,
    this.lastUpdateTime,
    this.isSystem,
    this.iconBytes,
  });

  /// Creates an [AppInfo] from a map of key-value pairs.
  ///
  /// The map typically comes from platform-specific implementations.
  /// Handles type conversion and null safety for various data types.
  factory AppInfo.fromMap(Map<String, Object?> m) {
    final int? firstInstallTime =
        m['firstInstallTime'] != null ? int.tryParse(m['firstInstallTime']!.toString()) : null;
    final DateTime? firstInstallTimeDate =
        firstInstallTime != null ? DateTime.fromMillisecondsSinceEpoch(firstInstallTime) : null;

    final int? lastUpdateTime =
        m['lastUpdateTime'] != null ? int.tryParse(m['lastUpdateTime']!.toString()) : null;
    final DateTime? lastUpdateTimeDate =
        lastUpdateTime != null ? DateTime.fromMillisecondsSinceEpoch(lastUpdateTime) : null;

    return AppInfo(
      packageName: m['packageName']?.toString(),
      appName: m['appName']?.toString(),
      versionName: m['versionName']?.toString(),
      versionCode: m['versionCode'] != null ? int.tryParse(m['versionCode']!.toString()) : null,
      firstInstallTime: firstInstallTimeDate,
      lastUpdateTime: lastUpdateTimeDate,
      isSystem: m['isSystem'] != null ? bool.tryParse(m['isSystem']!.toString()) : null,
      iconBytes:
          m['iconBytes'] is List<int> ? Uint8List.fromList(m['iconBytes']! as List<int>) : null,
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

  /// The date and time when the app was first installed on the device.
  final DateTime? firstInstallTime;

  /// The date and time when the app was last updated.
  final DateTime? lastUpdateTime;

  /// Whether the app is a system app (preinstalled) or user-installed.
  final bool? isSystem;

  /// The app icon as raw bytes, if requested and available.
  final Uint8List? iconBytes;

  /// Converts this [AppInfo] to a map representation.
  ///
  /// Useful for serialization to platform channels or other data formats.
  Map<String, Object?> toMap() => {
        'packageName': packageName,
        'appName': appName,
        'versionName': versionName,
        'versionCode': versionCode,
        'firstInstallTime': firstInstallTime?.millisecondsSinceEpoch,
        'lastUpdateTime': lastUpdateTime?.millisecondsSinceEpoch,
        'isSystem': isSystem,
        'iconBytes': iconBytes,
      };
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

  /// Best-effort: launches an app by package name. Returns false if not launchable.
  Future<bool> openApp(String packageName);

  /// Stream of app change events (install, uninstall, update).
  ///
  /// Platform implementations should emit [AppChangeEvent] objects when apps
  /// are installed, removed, or updated on the device.
  /// Call [startAppChangeStream] to begin receiving events.
  Stream<AppChangeEvent> get appChanges;

  /// Starts monitoring for app change events.
  ///
  /// Call this method to begin receiving app change events via [appChanges] stream.
  /// Platform implementations should set up necessary listeners or broadcast receivers.
  Future<void> startAppChangeStream();

  /// Stops monitoring for app change events.
  ///
  /// Call this method to stop receiving app change events and clean up resources.
  /// Platform implementations should remove listeners or unregister broadcast receivers.
  Future<void> stopAppChangeStream();

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

  /// Gets the installer store for the specified package name.
  ///
  /// Platform implementations should return the installer store for the given package.
  /// Returns the installer store name or null if not available.
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
  }) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<AppInfo?> getApp(String packageName, {bool includeIcon = false}) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> openApp(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Stream<AppChangeEvent> get appChanges =>
      Stream.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<void> startAppChangeStream() =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<void> stopAppChangeStream() =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> openAppSettings(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<bool> uninstallApp(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));

  @override
  Future<String?> getInstallerStore(String packageName) =>
      Future.error(UnsupportedError('FlutterDeviceAppsPlatform not implemented'));
}
