#include "include/libclash_vpn_service/libclash_vpn_service_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace {

class LibclashVpnServicePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LibclashVpnServicePlugin();

  virtual ~LibclashVpnServicePlugin();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

void LibclashVpnServicePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "libclash_vpn_service",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<LibclashVpnServicePlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

LibclashVpnServicePlugin::LibclashVpnServicePlugin() {}

LibclashVpnServicePlugin::~LibclashVpnServicePlugin() {}

void LibclashVpnServicePlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  result->NotImplemented();
}

}  // namespace

void LibclashVpnServicePluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  LibclashVpnServicePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
