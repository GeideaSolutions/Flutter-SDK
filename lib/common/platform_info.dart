import 'dart:io';

import 'package:flutter/services.dart';

/// Holds data that's different on Android and iOS
class PlatformInfo {
  final String userAgent;
  final String GeideapayBuild;
  final String deviceId;

  static Future<PlatformInfo> fromMethodChannel(MethodChannel channel) async {
    // TODO: Update for every new versions.
    //  And there should a better way to fucking do this
    const pluginVersion = "1.0.5";

    final platform = Platform.operatingSystem;
    String userAgent = "${platform}_Geideapay_$pluginVersion";
    String deviceId = await channel.invokeMethod('getDeviceId') ?? "";
    return PlatformInfo._(
      userAgent: userAgent,
      GeideapayBuild: pluginVersion,
      deviceId: deviceId,
    );
  }

  const PlatformInfo._({
    required String userAgent,
    required String GeideapayBuild,
    required String deviceId,
  })   : userAgent = userAgent,
        GeideapayBuild = GeideapayBuild,
        deviceId = deviceId;

  @override
  String toString() {
    return '[userAgent = $userAgent, GeideapayBuild = $GeideapayBuild, deviceId = $deviceId]';
  }
}
