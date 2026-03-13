class VpnServiceResultError {
  final int code;
  final String message;

  VpnServiceResultError({
    required this.code,
    required this.message,
  });
}

enum VpnServiceWaitType {
  done,
  timeout,
  error
}

class VpnServiceWaitResult {
  final bool success;
  final String? message;
  final VpnServiceWaitType type;
  final VpnServiceResultError? err;

  VpnServiceWaitResult({
    required this.success,
    this.message,
    this.type = VpnServiceWaitType.done,
    this.err,
  });
}

class VpnServiceConfig {
  String? configPath;
  bool? enableDns;
  bool? enableIpv6;
  int? mtu;
  List<String>? dnsServers;
  Map<String, dynamic>? extraOptions;
  String? install_refer;
  bool? prepare;
  bool? wake_lock;
  bool? auto_connect_at_boot;
  String? log_path;
  String? err_path;
  String? id;
  String? version;
  String? name;
  String? secret;
  int? control_port;
  String? base_dir;
  String? work_dir;
  String? cache_dir;
  String? core_path;
  String? core_path_patch;
  String? core_path_patch_final;

  VpnServiceConfig({
    this.configPath,
    this.enableDns,
    this.enableIpv6,
    this.mtu,
    this.dnsServers,
    this.extraOptions,
    this.install_refer,
    this.prepare,
    this.wake_lock,
    this.auto_connect_at_boot,
    this.log_path,
    this.err_path,
    this.id,
    this.version,
    this.name,
    this.secret,
    this.control_port,
    this.base_dir,
    this.work_dir,
    this.cache_dir,
    this.core_path,
    this.core_path_patch,
    this.core_path_patch_final,
  });

  Map<String, dynamic> toJson() {
    return {
      'configPath': configPath,
      'enableDns': enableDns,
      'enableIpv6': enableIpv6,
      'mtu': mtu,
      'dnsServers': dnsServers,
      'extraOptions': extraOptions,
      'install_refer': install_refer,
      'prepare': prepare,
      'wake_lock': wake_lock,
      'auto_connect_at_boot': auto_connect_at_boot,
      'log_path': log_path,
      'err_path': err_path,
      'id': id,
      'version': version,
      'name': name,
      'secret': secret,
      'control_port': control_port,
      'base_dir': base_dir,
      'work_dir': work_dir,
      'cache_dir': cache_dir,
      'core_path': core_path,
      'core_path_patch': core_path_patch,
      'core_path_patch_final': core_path_patch_final,
    };
  }

  void fromJson(Map<String, dynamic> json) {
    configPath = json['configPath'];
    enableDns = json['enableDns'];
    enableIpv6 = json['enableIpv6'];
    mtu = json['mtu'];
    dnsServers = json['dnsServers'] != null
        ? List<String>.from(json['dnsServers'])
        : null;
    extraOptions = json['extraOptions'];
    install_refer = json['install_refer'];
    prepare = json['prepare'];
    wake_lock = json['wake_lock'];
    auto_connect_at_boot = json['auto_connect_at_boot'];
    log_path = json['log_path'];
    err_path = json['err_path'];
    id = json['id'];
    version = json['version'];
    name = json['name'];
    secret = json['secret'];
    control_port = json['control_port'];
    base_dir = json['base_dir'];
    work_dir = json['work_dir'];
    cache_dir = json['cache_dir'];
    core_path = json['core_path'];
    core_path_patch = json['core_path_patch'];
    core_path_patch_final = json['core_path_patch_final'];
  }
}
