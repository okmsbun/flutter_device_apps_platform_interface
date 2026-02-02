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