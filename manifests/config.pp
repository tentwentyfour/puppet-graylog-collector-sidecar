# == Class gcs::config
#
# Generates the collector-sidecar configuration file.
#
# === Parameters
#
# This class does not provide any parameters.
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
# === Authors
#
# David Raison <david@tentwentyfour.lu>
#
class gcs::config {

  if $module_name != $caller_module_name {
    fail("gcs::config is a private class of the module gcs, you're not permitted to use it.")
  }

  $conf_dir         = $::gcs::params::conf_dir
  $server_url       = $::gcs::server_url
  $tags             = $::gcs::tags
  $log_files        = $::gcs::log_files
  $update_interval  = $::gcs::update_interval
  $tls_skip_verify  = $::gcs::tls_skip_verify
  $send_status      = $::gcs::send_status
  $filebeat_enable  = $::gcs::filebeat_enable
  $nxlog_enable     = $::gcs::nxlog_enable

  file { "${conf_dir}/collector_sidecar.yml":
    ensure    => file,
    owner     => root,
    group     => root,
    mode      => '0640',
    content   => template("${module_name}/sidecar/collector_sidecar.yml.erb"),
    show_diff => true,
  }

}
