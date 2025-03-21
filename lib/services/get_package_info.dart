import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<PackageInfo> getPackageInfo() async {

  final prefs = GetStorage();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  prefs.write("appBuildNumber", packageInfo.buildNumber);
  prefs.write("appVersion", packageInfo.version);
  prefs.write("packageName", packageInfo.packageName);

  return packageInfo;
}