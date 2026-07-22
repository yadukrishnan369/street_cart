import 'dart:io';
import 'network_info.dart';

class NetworkInfoMobile implements INetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

INetworkInfo getNetworkInfo() => NetworkInfoMobile();
