import 'package:flutter_device_apps_platform_interface/flutter_device_apps_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  test('an unregistered platform still reports unsupported operations', () async {
    final FlutterDeviceAppsPlatform platform = FlutterDeviceAppsPlatform.instance;
    await expectLater(platform.listApps(packageNamePrefix: 'com.example.'), throwsUnsupportedError);
    await expectLater(platform.getAppIcon('com.example.user'), throwsUnsupportedError);
    await expectLater(platform.isAppInstalled('com.example.user'), throwsUnsupportedError);
    await expectLater(platform.isSystemApp('com.example.user'), throwsUnsupportedError);
    await expectLater(platform.isAppEnabled('com.example.user'), throwsUnsupportedError);
    await expectLater(platform.isAppLaunchable('com.example.user'), throwsUnsupportedError);
    await expectLater(platform.getInstallSourceInfo('com.example.user'), throwsUnsupportedError);
  });
}
