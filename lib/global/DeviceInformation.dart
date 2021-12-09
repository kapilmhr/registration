import 'package:flutter/services.dart';

class DeviceInformation {
  static const MethodChannel _channel =
      const MethodChannel('device_information');

  static Future<String> get deviceIMEINumber async {
    final imeiNo = await _channel.invokeMethod("getIMEINumber");
    return imeiNo == null ? "" : imeiNo;
  }
}
