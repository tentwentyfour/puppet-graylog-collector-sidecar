# == Class gcs::params
#
# Sets default parameters for the module.
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
class gcs::params {

  $ensure           = running
  $enable           = true
  $install_service  = true
  $server_url       = undef
  $tags             = []
  $package_version  = '0.1.3'
  $package_revision = 1
  $log_files        = ['/var/log']
  $update_interval  = 10
  $tls_skip_verify  = false
  $send_status      = true
  $conf_path        = '/etc/graylog/collector-sidecar/collector_sidecar.yml'
  $service          = 'collector-sidecar'
  $filebeat_enable  = true
  $nxlog_enable     = false
  $manage_cache_dir = true
  $puppet_cache     = '/var/cache/puppet'
  $archive_dir      = "${puppet_cache}/archives"
  $checksum_type    = 'sha256'
  $download_url     = undef
  $package_name     = 'collector-sidecar'
  $package_repo     = false
  $node_id_prefix   = 'graylog-collector-sidecar-'

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '8.04') < 1 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
      $service_provider = 'upstart'
      $package_provider = 'dpkg'
      $checksum         = 'd52ae3530452f0622f215af986b80af8f1e3e340218786d132c3a75b667aadf3'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.deb"
    } else {
      $service_provider = 'systemd'
      $package_provider = 'dpkg'
      $checksum         = 'd52ae3530452f0622f215af986b80af8f1e3e340218786d132c3a75b667aadf3'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.deb"
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $service_provider = 'systemd'
      $package_provider = 'dpkg'
      $checksum         = 'd52ae3530452f0622f215af986b80af8f1e3e340218786d132c3a75b667aadf3'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.deb"
    }
  } elsif $::operatingsystem =~ /CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $service_provider = 'systemd'
      $package_provider = 'rpm'
      $checksum         = '0338eab5715210cb5541d2aefabbd668e19010a4339dd2ab7187a066f0541a05'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.rpm"
    }
  } else {
    fail("Your plattform ${::operatingsystem} is not supported, yet.")
  }

}
