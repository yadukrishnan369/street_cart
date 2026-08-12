import 'package:web/web.dart' as web;
import 'network_info.dart';

class NetworkInfoWeb implements INetworkInfo {
  @override
  Future<bool> get isConnected async {
    return web.window.navigator.onLine;
  }
}

INetworkInfo getNetworkInfo() => NetworkInfoWeb();
