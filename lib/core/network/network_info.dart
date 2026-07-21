import 'package:flutter/foundation.dart';
import 'dart:io' as io;
import 'dart:js_interop';

@JS('navigator.onLine')
external bool get _isOnline;

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements INetworkInfo {
  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      try {
        return _isOnline;
      } catch (_) {
        return true;
      }
    } else {
      try {
        final result = await io.InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
  }
}
