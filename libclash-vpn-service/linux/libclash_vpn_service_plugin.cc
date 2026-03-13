#include "include/libclash_vpn_service/libclash_vpn_service_plugin.h"

#include <flutter_linux/flutter_linux.h>

#define LIBCLASH_VPN_SERVICE_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), libclash_vpn_service_plugin_get_type(), \
                               LibclashVpnServicePlugin))

struct _LibclashVpnServicePlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(LibclashVpnServicePlugin, libclash_vpn_service_plugin, g_object_get_type())

static void libclash_vpn_service_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(libclash_vpn_service_plugin_parent_class)->dispose(object);
}

static void libclash_vpn_service_plugin_class_init(LibclashVpnServicePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = libclash_vpn_service_plugin_dispose;
}

static void libclash_vpn_service_plugin_init(LibclashVpnServicePlugin* self) {}

void libclash_vpn_service_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  LibclashVpnServicePlugin* plugin = LIBCLASH_VPN_SERVICE_PLUGIN(
      g_object_new(libclash_vpn_service_plugin_get_type(), nullptr));

  g_object_unref(plugin);
}
