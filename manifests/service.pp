# == Class gcs::service
#
# Handles service initialization for the collector-sidecar
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
class gcs::service {

  $manage_service = $::gcs::manage_service
  $service        = $::gcs::params::service

  if $manage_service {

    exec { 'install_gcs_service':
      command => '/usr/bin/graylog-collector-sidecar -service install',
      creates => '/etc/systemd/system/collector-sidecar.service',
    }~>
    service { $service:
      ensure     => $::gcs::ensure,
      enable     => $::gcs::enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
