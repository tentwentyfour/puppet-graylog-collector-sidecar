# == Class gcs::install
#
# Retrieves and installs the graylog-collector-sidecar package.
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
class gcs::install {

  if $module_name != $caller_module_name {
    fail("gcs::install is a private class of the module gcs, you're not permitted to use it.")
  }

  if $::gcs::manage_cache_dir {
    file { $::gcs::puppet_cache:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { $::gcs::archive_dir:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => File[$::gcs::puppet_cache],
    }
  }

  remote_file { 'retrieve_gcs':
    ensure        => present,
    path          => $::gcs::download_package,
    source        => $::gcs::download_url,
    checksum_type => $::gcs::checksum_type,
    checksum      => $::gcs::checksum,
  }

  package { $::gcs::service:
    ensure   => present,
    source   => $::gcs::download_package,
    provider => $::gcs::package_provider,
    require  => Remote_file['retrieve_gcs'],
  }

  if $::gcs::manage_service {
    if $::gcs::service_provider == 'systemd' {
      exec { 'install_gcs_service':
        command => '/usr/bin/graylog-collector-sidecar -service install',
        creates => '/etc/systemd/system/collector-sidecar.service',
      }
    } elsif $::gcs::service_provider == 'upstart' {
      exec { 'install_gcs_service':
        command => '/usr/bin/graylog-collector-sidecar -service install',
        creates => '/etc/init/collector-sidecar.conf',
      }
    }
  } ~> Service[$::gcs::service]

}
