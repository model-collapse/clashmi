import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'state.dart';

abstract class VpnServicePlatform extends PlatformInterface {
  VpnServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static VpnServicePlatform? _instance;

  static VpnServicePlatform get instance => _instance ?? _DefaultVpnServicePlatform();

  static set instance(VpnServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

class _DefaultVpnServicePlatform extends VpnServicePlatform {}
