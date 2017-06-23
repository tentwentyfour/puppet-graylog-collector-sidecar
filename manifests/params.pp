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
  $manage_service   = true
  $server_url       = undef
  $tags             = []
  $package_version  = '0.1.0'
  $package_revision = 1
  $log_files        = ['/var/log']
  $update_interval  = 10
  $tls_skip_verify  = false
  $send_status      = true
  $conf_dir         = '/etc/graylog/collector-sidecar'
  $service          = 'collector-sidecar'
  $filebeat_enable  = true
  $nxlog_enable     = false
  $manage_cache_dir = true
  $puppet_cache     = '/var/cache/puppet'
  $archive_dir      = "${puppet_cache}/archives"
  $checksum_type    = 'sha256'

  $version_parts = $package_version.match(/(\d)\.(\d)\.(\d)(-+.*)?/)

  if !is_array($version_parts) {
    fail("There was a problem parsing the package_version ${package_version}.")
  }

  $major_version    = $version_parts[1]
  $minor_version    = $version_parts[2]
  $patch_level      = $version_parts[3]
  $version_suffix   = $version_parts[4]

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '8.04') < 1 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
      $service_provider = 'upstart'
      $package_provider = 'dpkg'
      $checksum         = '30a0c3feffbca2a95e823788162f17828874e00a423bcc314a0e353949d4282b'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.deb"
      $download_url     = "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar_${major_version}.${minor_version}.${patch_level}${version_suffix}-${package_revision}_${::architecture}.deb"
    } else {
      $service_provider = 'systemd'
      $package_provider = 'dpkg'
      $checksum         = '30a0c3feffbca2a95e823788162f17828874e00a423bcc314a0e353949d4282b'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.deb"
      $download_url     = "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar_${major_version}.${minor_version}.${patch_level}${version_suffix}-${package_revision}_${::architecture}.deb"
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $service_provider = 'systemd'
      $package_provider = 'dpkg'
      $checksum         = '30a0c3feffbca2a95e823788162f17828874e00a423bcc314a0e353949d4282b'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.deb"
      $download_url     = "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar_${major_version}.${minor_version}.${patch_level}${version_suffix}-${package_revision}_${::architecture}.deb"
    }
  } elsif $::operatingsystem =~ /CentOS|RedHat/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $service_provider = 'systemd'
      $package_provider = 'rpm'
      $checksum         = 'b343a7b5e72f134717feb49c375325d89b3524dbb635d58928a0ccaa36252747'
      $download_package = "${archive_dir}/collector-sidecar.${package_version}.rpm"
      $download_url     = "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar-${major_version}.${minor_version}.${patch_level}${version_suffix}-${package_revision}.${::architecture}.rpm"
    }
  } else {
    fail("Your plattform ${::operatingsystem} is not supported, yet.")
  }

}
