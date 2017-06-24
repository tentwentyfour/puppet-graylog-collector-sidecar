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

  $version_parts = $::gcs::package_version.match(/(\d)\.(\d)\.(\d)(-+.*)?/)

  if !is_array($version_parts) {
    fail("There was a problem parsing the package_version ${::gcs::package_version}.")
  }

  $major_version    = $version_parts[1]
  $minor_version    = $version_parts[2]
  $patch_level      = $version_parts[3]
  $version_suffix   = $version_parts[4]


  if empty($::gcs::download_url) {
    $download_url = $::osfamily ? {
      'debian' => "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar_${major_version}.${minor_version}.${patch_level}${version_suffix}-${::gcs::package_revision}_${::architecture}.deb",
      'redhat' => "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar-${major_version}.${minor_version}.${patch_level}${version_suffix}-${::gcs::package_revision}.${::architecture}.rpm",
      default  => fail("${::osfamily} is not supported!"),
    }
  }

  if !empty($::gcs::download_url) {
    $download_url = $::gcs::download_url
  }

  remote_file { 'retrieve_gcs':
    ensure        => present,
    path          => $::gcs::download_package,
    source        => $download_url,
    checksum_type => $::gcs::checksum_type,
    checksum      => $::gcs::checksum,
  }

  package { $::gcs::service:
    ensure   => present,
    source   => $::gcs::download_package,
    provider => $::gcs::package_provider,
    require  => Remote_file['retrieve_gcs'],
  }

  if $::gcs::install_service {
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
