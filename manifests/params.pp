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

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '8.04') < 1 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
      $service_provider = 'upstart'
    } else {
      $service_provider = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $service_provider = 'systemd'
    }
  } elsif $::operatingsystem =~ /CentOS|RedHat/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $init_style  = 'systemd'
    }
  } else {
    fail("Your plattform ${::operatingsystem} is not supported, yet.")
  }

  # On Debian, auto-detected 'debian' service_provider will attempt to start service using non-existent init.d script first.
  # See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=775795
  $tmp_location     = '/tmp'
  $conf_dir         = '/etc/graylog/collector-sidecar'
  $log_files        = [ '/var/log' ]
  $service          = 'collector-sidecar'
  $update_interval  = 10
  $tls_skip_verify  = false
  $send_status      = true
  $filebeat_enable  = true
  $nxlog_enable     = false

}
