## 1.0.0

- **BREAKING**: Raised the minimum Dart SDK version to 3.12.0.
- **BREAKING**: Platform implementations must implement the new abstract query methods and accept `packageNamePrefix` in their `listApps` override.
- Added `isAppInstalled`, `isSystemApp`, `isAppEnabled`, and `isAppLaunchable` to query app state without loading full app metadata.
- Added `getAppIcon` to retrieve an app icon separately as PNG bytes.
- Added `getInstallSourceInfo` and the `AppInstallSourceInfo` model with `installingPackageName`, `initiatingPackageName`, `originatingPackageName`, `packageSource`, and `updateOwnerPackageName`.
- Deprecated `getInstallerStore`. Use `getInstallSourceInfo` and its `installingPackageName` field instead.
- Added the optional `packageNamePrefix` filter to `listApps`. Matching is case-sensitive; null or empty disables the filter.
- Updated package topics and directed issue reports to the main `flutter_device_apps` repository.

## 0.7.0
- Expanded `AppInfo` with additional Android raw metadata fields: `uid`, `apkPath`, `apkSizeBytes`, `dataPath`, and `isOnExternalStorage`.
- Updated `AppInfo` unit tests to cover parsing and null-safety behavior for the new fields.

## 0.6.0
- **BREAKING**: Removed `requestedPermissions` field from `AppInfo` class to improve performance and reduce memory usage
- Added new API: `getRequestedPermissions(String packageName)` to fetch app permissions on demand
- Added comprehensive unit tests for `AppInfo`, `AppChangeType`, and `AppChangeEvent` classes

## 0.5.1
- Expanded `AppInfo` with additional Android-facing fields: `category`, `targetSdkVersion`, `minSdkVersion`, `enabled`, `processName`, `installLocation`, `requestedPermissions`.

## 0.4.0
App change events now forward the raw Android action string to Dart, which maps it to AppChangeType without breaking existing API.

## 0.2.0
- Enhanced README.md with professional badge layout for better package visibility
- Added centered HTML badges for pub.dev, GitHub stars, Flutter documentation, and MIT license
- Improved documentation presentation and accessibility following modern Flutter package standards
- Added links to relevant Flutter documentation (deep-linking) for better developer guidance
- Updated package branding and visual consistency across federated plugin family

## 0.1.2
- **BREAKING**: Removed `AppChangeType.enabled` and `AppChangeType.disabled` enum values
- These event types were defined but never implemented in the Android platform, causing confusion
- Only `AppChangeType.installed`, `AppChangeType.removed`, and `AppChangeType.updated` are now supported
- Updated `_parseType` method to only handle the three implemented event types
- Updated documentation comments to reflect actual supported event types
- Added new API: `openAppSettings(String packageName)` to open system app settings screen
- Added new API: `uninstallApp(String packageName)` to launch the system uninstall UI
- Added new API: `getInstallerStore(String packageName)` to retrieve the installer package name (e.g., Play Store)

## 0.1.1
- Update pubspec.yaml to bump version to 0.1.1 and upgrade lints dependency to version 6.0.0.

## 0.1.0
- Initial release of platform interface for flutter_device_apps
- Defines AppInfo, AppChangeEvent, and FlutterDeviceAppsPlatform contract
