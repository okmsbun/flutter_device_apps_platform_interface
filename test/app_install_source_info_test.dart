import 'package:flutter_device_apps_platform_interface/flutter_device_apps_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  test('parses installation source metadata from a platform map', () {
    final AppInstallSourceInfo info = AppInstallSourceInfo.fromMap({
      'installingPackageName': 'com.android.vending',
      'initiatingPackageName': 'com.example.installer',
      'originatingPackageName': 'com.example.browser',
      'packageSource': 2,
      'updateOwnerPackageName': 'com.example.owner',
    });

    expect(info.installingPackageName, 'com.android.vending');
    expect(info.initiatingPackageName, 'com.example.installer');
    expect(info.originatingPackageName, 'com.example.browser');
    expect(info.packageSource, 2);
    expect(info.updateOwnerPackageName, 'com.example.owner');
  });

  test('preserves unavailable fields in legacy and empty responses', () {
    final AppInstallSourceInfo legacy = AppInstallSourceInfo.fromMap({
      'installingPackageName': 'com.android.vending',
    });
    final AppInstallSourceInfo unknown = AppInstallSourceInfo.fromMap({});

    expect(legacy.installingPackageName, 'com.android.vending');
    expect(legacy.initiatingPackageName, isNull);
    expect(legacy.originatingPackageName, isNull);
    expect(legacy.packageSource, isNull);
    expect(legacy.updateOwnerPackageName, isNull);
    expect(unknown.installingPackageName, isNull);
    expect(unknown.packageSource, isNull);
  });

  test('distinguishes unspecified source from unavailable or invalid source', () {
    expect(AppInstallSourceInfo.fromMap({'packageSource': 0}).packageSource, 0);
    expect(AppInstallSourceInfo.fromMap({'packageSource': '2'}).packageSource, 2);
    expect(AppInstallSourceInfo.fromMap({'packageSource': 'invalid'}).packageSource, isNull);
    expect(AppInstallSourceInfo.fromMap({'packageSource': null}).packageSource, isNull);
  });
}
