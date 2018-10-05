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
  $ensure           = $::gcs::ensure
  $conf_path        = $::gcs::conf_path
  $server_url       = $::gcs::server_url
  $tags             = $::gcs::tags
  $log_files        = $::gcs::log_files
  $update_interval  = $::gcs::update_interval
  $tls_skip_verify  = $::gcs::tls_skip_verify
  $send_status      = $::gcs::send_status
  $filebeat_enable  = $::gcs::filebeat_enable
  $nxlog_enable     = $::gcs::nxlog_enable
  $node_id_prefix   = $::gcs::node_id_prefix

  if $ensure != stopped {
    file { $conf_path:
      ensure    => file,
      owner     => root,
      group     => root,
      mode      => '0640',
      content   => template("${module_name}/sidecar/collector_sidecar.yml.erb"),
      show_diff => true,
    }
  }

}
