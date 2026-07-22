import 'dart:html' as html;
import 'network_info.dart';

class NetworkInfoWeb implements INetworkInfo {
  @override
  Future<bool> get isConnected async {
    return html.window.navigator.onLine ?? false;
  }
}

INetworkInfo getNetworkInfo() => NetworkInfoWeb();
