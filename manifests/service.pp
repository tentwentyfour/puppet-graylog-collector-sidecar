# == Class gcs::service
#
# Handles service initialization for the collector-sidecar
#
# On Debian, auto-detected 'debian' service_provider will attempt to start service using non-existent init.d script first.
# See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=775795
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

  service { $::gcs::service:
    ensure     => $::gcs::ensure,
    enable     => $::gcs::enable,
    provider   => $::gcs::service_provider,
    hasstatus  => true,
    hasrestart => true,
  }

}
