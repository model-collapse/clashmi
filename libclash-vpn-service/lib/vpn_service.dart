import 'dart:async';
import 'dart:io';
import 'state.dart';
import 'vpn_service_result.dart';

class FlutterVpnService {
  static Future<String> getABIs() async {
    return '[]';
  }

  static Future<bool> isRunAsAdmin() async {
    return false;
  }

  static Future<void> firewallAddApp(String path, String name) async {
    // No-op for stub
  }

  static Future<void> firewallAddPorts(List<int> ports, String name) async {
    // No-op for stub
  }

  static void onStateChanged(
    void Function(FlutterVpnServiceState state, Map<String, String> params) callback
  ) {
    // Register callback (no-op in stub)
  }

  static Future<void> cleanSystemProxy() async {
    // No-op for stub
  }

  static Future<VpnServiceWaitResult> start(Duration timeout) async {
    return VpnServiceWaitResult(success: true);
  }

  static Future<void> stop() async {
    // No-op for stub
  }

  static Future<FlutterVpnServiceState> getState() async {
    return FlutterVpnServiceState.disconnected;
  }

  static Future<String> getSystemVersion() async {
    if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isMacOS) {
      return 'macOS';
    }
    return 'Unknown';
  }

  static Future<void> hideDockIcon(bool hide) async {
    // No-op for stub
  }

  static Future<void> prepareConfig({VpnServiceConfig? config, String? tunnelServicePath, String? configFilePath, bool? systemExtension, String? bundleIdentifier, String? uiServerAddress, String? uiLocalizedDescription, List<int>? excludePorts}) async {
    // No-op for stub
  }

  static Future<VpnServiceResultError?> installService() async {
    return null;
  }

  static Future<VpnServiceResultError?> uninstallService() async {
    return null;
  }

  static Future<void> setAlwaysOn(bool enabled) async {
    // No-op for stub
  }

  static Future<VpnServiceWaitResult> restart(Duration timeout) async {
    return VpnServiceWaitResult(success: true);
  }

  static Future<Directory?> getAppGroupDirectory(String groupId) async {
    return null;
  }

  static Future<VpnServiceResultError?> setExcludeFromRecents(bool exclude) async {
    return null;
  }

  static Future<bool> isServiceAuthorized(String servicePath) async {
    return true;
  }

  static Future<VpnServiceResultError?> authorizeService(String servicePath, String password) async {
    return null;
  }

  static Future<String> clashiApiConnections(bool reset) async {
    return '[]';
  }

  static Future<String> clashiApiTraffic() async {
    return '{"up": 0, "down": 0}';
  }

  static Future<void> setSystemProxy(dynamic proxyOption) async {
    // No-op for stub
  }

  static Future<void> clearSystemProxy() async {
    // No-op for stub
  }

  static Future<FlutterVpnServiceState> get currentState async {
    return FlutterVpnServiceState.disconnected;
  }

  static Future<bool> getSystemProxyEnable(dynamic proxyOption) async {
    return false;
  }

  static Future<void> autoStartCreate(String taskName, String exePath, {String? processArgs, bool? runElevated}) async {
    // No-op for stub
  }

  static Future<void> autoStartDelete(String taskName) async {
    // No-op for stub
  }

  static Future<bool> autoStartIsActive(String taskName) async {
    return false;
  }
}
