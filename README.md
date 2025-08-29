# flutter\_device\_apps\_platform\_interface

Platform interface for the [flutter\_device\_apps](https://pub.dev/packages/flutter_device_apps) federated plugin.

This package defines the common API contract (Dart side) that all platform implementations of `flutter_device_apps` must follow.

---

## ✨ What it provides

* `AppInfo` model → metadata for installed apps (package name, version, install/update times, system flag, optional icon bytes).
* `AppChangeEvent` model → events for install, uninstall, update, enable, disable.
* `FlutterDeviceAppsPlatform` abstract class → base interface every platform package must extend.
  - `listApps()` - List installed applications
  - `getApp()` - Get details for a specific app
  - `openApp()` - Launch an application
  - `openAppSettings()` - Open app settings page
  - `uninstallApp()` - Uninstall an application
  - `getInstallerStore()` - Get installer store information
  - `appChanges` - Stream of app change events
  - `startAppChangeStream()` / `stopAppChangeStream()` - Control event monitoring

---

## 🚫 When NOT to use this package

You should **not** depend on this package directly in your Flutter apps.

Instead, use the umbrella package:

```yaml
dependencies:
  flutter_device_apps: latest_version
```

This interface is only intended for platform implementors (e.g. `flutter_device_apps_android`).

---

## 🛠 For platform implementors

To add support for a new platform:

1. Create a new package (e.g. `flutter_device_apps_linux`).

2. Add a dependency on this package:

   ```yaml
   dependencies:
     flutter_device_apps_platform_interface: latest_version
   ```

3. Extend `FlutterDeviceAppsPlatform` and override the required methods:

   ```dart
   class FlutterDeviceAppsLinux extends FlutterDeviceAppsPlatform {
     @override
     Future<List<AppInfo>> listApps({bool includeSystem = false, bool onlyLaunchable = true, bool includeIcons = false}) {
       // implement using Linux APIs
     }

     @override
     Future<AppInfo?> getApp(String packageName, {bool includeIcon = false}) {
       // implement
     }

     @override
     Future<bool> openApp(String packageName) {
       // implement
     }

     @override
     Future<bool> openAppSettings(String packageName) {
       // implement - open app settings page
     }

     @override
     Future<bool> uninstallApp(String packageName) {
       // implement - uninstall app
     }

     @override
     Future<String?> getInstallerStore(String packageName) {
       // implement - get installer store information
     }

     @override
     Stream<AppChangeEvent> get appChanges => _streamController.stream;

     @override
     Future<void> startAppChangeStream() async {
       // setup listener
     }

     @override
     Future<void> stopAppChangeStream() async {
       // tear down listener
     }
   }
   ```

4. Register your implementation by setting:

   ```dart
   FlutterDeviceAppsPlatform.instance = FlutterDeviceAppsLinux();
   ```

---

## 📄 License

MIT © 2025 okmsbun
