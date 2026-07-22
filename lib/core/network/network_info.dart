import 'network_info_mobile.dart'
    if (dart.library.html) 'network_info_web.dart';

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements INetworkInfo {
  final INetworkInfo _platformNetworkInfo = getNetworkInfo();

  @override
  Future<bool> get isConnected => _platformNetworkInfo.isConnected;
}
