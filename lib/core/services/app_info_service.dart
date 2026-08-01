import 'package:package_info_plus/package_info_plus.dart';

abstract class IAppInfoService {
  Future<void> init();
  String get appName;
  String get packageName;
  String get version;
  String get buildNumber;
  String get fullVersionString;
  int get currentYear;
  String getCopyrightText([String suffix = '']);
}

class AppInfoService implements IAppInfoService {
  PackageInfo? _packageInfo;

  @override
  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  String get appName {
    final name = _packageInfo?.appName;
    if (name == null || name.isEmpty || name == 'street_cart') {
      return 'Street Cart';
    }
    if (name.contains('_')) {
      return name
          .split('_')
          .map(
            (word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '',
          )
          .join(' ');
    }
    return name;
  }

  @override
  String get packageName => _packageInfo?.packageName ?? '';

  @override
  String get version => _packageInfo?.version ?? '1.0.0';

  @override
  String get buildNumber => _packageInfo?.buildNumber ?? '1';

  @override
  String get fullVersionString => 'Version $version';

  @override
  int get currentYear => DateTime.now().year;

  @override
  String getCopyrightText([String suffix = '']) {
    final name = appName;
    final extra = suffix.isNotEmpty ? ' $suffix' : '';
    return '© $currentYear $name$extra';
  }
}
