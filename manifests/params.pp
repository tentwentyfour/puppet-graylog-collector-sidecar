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

  case $::kernel {
    'linux': {
      case $::osfamily {
        default: {
          $service_provider = 'systemd'
        }
      }
    }

    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
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
