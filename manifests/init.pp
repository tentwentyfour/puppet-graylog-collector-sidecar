# == Class: gcs
#
# This module installs graylog collector-sidecar, manages its service and
#
# === Parameters
#
# [*ensure*]
#   Valid values are running or stopped.
#
# [*enable*]
#   Whether to enable the collector-sidecar service.
#
# [*manage_service*]
#   Whether or not to manage (install, launch/stop) the collector-sidecar service.
#
# [*download_url*]
#   URL to download package from.
#   By default, the package is downloaded from the graylog collector github release page.
#
# [*package_version*]
#   Which package version to install.
#
# [*server_url*]
#   URL to the api of your graylog server. Collector-sidecar will fetch configurations.
#   from this host based on the configured tags.
#
# [*tags*]
#   Tags for this host
#
# [*log_files*]
#   Location of log files to index and report to the Graylog server.
#
# [*update_interval*]
#   The interval in seconds the sidecar will fetch new configurations from the Graylog server.
#   Default is set to 10 in params.
#
# [*tls_skip_verify*]
#   Ignore errors when the REST API was started with a self-signed certificate.
#
# [*send_status*]
#   Send the status of each backend back to Graylog and display it on the status page for the host.
#
# === Examples
#
#  include ::gcs
#
# In hiera, you can set configuration variables:
#  gcs::server_url: http://my.graylog.server:9000/api
#  gcs::update_interval: 15
#  gcs::tags:
#    - linux
#    - icinga2
#    - nginx
#
# === Authors
#
# David Raison <david@tentwentyfour.lu>
#
class gcs(
  $ensure           = running,
  $enable           = true,
  $manage_service   = true,
  $download_url     = $gcs::params::download_url,
  $package_version  = $gcs::params::package_version,
  $server_url       = undef,
  $tags             = [],
  $log_files        = $gcs::params::log_files,
  $update_interval  = $gcs::params::update_interval,
  $tls_skip_verify  = $gcs::params::tls_skip_verify,
  $send_status      = $gcs::params::send_status,
) inherits ::gcs::params {

  validate_re($ensure, [ '^running$', '^stopped$' ],
    "${ensure} isn't supported. Valid values are 'running' and 'stopped'.")
  validate_bool($enable)
  validate_bool($manage_service)
  validate_array($tags)
  validate_absolute_path($log_files)
  validate_integer($update_interval)

  if !is_string($server_url) {
    fail('server_url must be set.')
  }

  anchor { '::gcs::begin': }
  -> class { '::gcs::install': }
  -> class { '::gcs::config': }
  ~> class { '::gcs::service': }
  anchor { '::gcs::end': }
}
