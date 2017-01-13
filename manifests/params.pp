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

  $package_version  = '0.1.0-beta.3'
  $version_parts = "${package_version}".match(/(\d)\.(\d)\.(\d)(-+.*)/)

  if !is_array($version_parts) {
    fail('You must specify a package version in the format 0.1.0-beta.2')
  }

  $major_version = $version_parts[1]
  $minor_version = $version_parts[2]
  $patch_level   = $version_parts[3]
  $extra_level   = $version_parts[4]

  case $::kernel {
    'linux': {
      # OK, no code yet, but this is a supported kernel
    }

    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
  }

  # On Debian, auto-detected 'debian' service_provider will attempt to start service using non-existent init.d script first.
  # See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=775795
  $service_provider = 'systemd'
  $conf_dir         = '/etc/graylog/collector-sidecar'
  $log_files        = [ '/var/log' ]
  $service          = 'collector-sidecar'
  $update_interval  = 10
  $tls_skip_verify  = false
  $send_status      = true

  $download_url = $::osfamily ? {
    'debian' => "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${extra_level}/collector-sidecar_${major_version}.${minor_version}-${patch_level}_${::architecture}.deb",
    # 'redhat' => "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${patch_level}/collector-sidecar_${major_version}.0-1.${::architecture}.rpm",
    default  => fail("${::osfamily} is not supported!"),
  }

}
