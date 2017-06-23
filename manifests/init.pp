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
# [*package_version*]
#   Which package version to install.
#
# [*package_revision*]
#   Which package revision to install. Defaults to 1 (For most versions there is only one
#   revision.)
#
# [*server_url*]
#   URL to the API of your graylog server. Collector-sidecar will fetch configurations.
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
# [*service_provider*]
#   Service provider to use. Defaults to systemd on linux.
#
# [*filebeat_enable*]
#    Whether to enable the filebeat service. Default: true
#
# [*nxlog_enable*]
#    Whether to enable the nxlog service. Default: false
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
  $ensure           = $gcs::params::ensure,
  $enable           = $gcs::params::enable,
  $manage_service   = $gcs::params::manage_service,
  $server_url       = $gcs::params::server_url,
  $tags             = $gcs::params::tags,
  $package_version  = $gcs::params::package_version,
  $package_revision = $gcs::params::package_revision,
  $log_files        = $gcs::params::log_files,
  $update_interval  = $gcs::params::update_interval,
  $tls_skip_verify  = $gcs::params::tls_skip_verify,
  $send_status      = $gcs::params::send_status,
  $conf_dir         = $gcs::params::conf_dir,
  $service          = $gcs::params::service,
  $filebeat_enable  = $gcs::params::filebeat_enable,
  $nxlog_enable     = $gcs::params::nxlog_enable,
  $manage_cache_dir = $gcs::params::manage_cache_dir,
  $puppet_cache     = $gcs::params::puppet_cache,
  $archive_dir      = $gcs::params::archive_dir,
  $checksum_type    = $gcs::params::checksum_type,
  $service_provider = $gcs::params::service_provider,
  $package_provider = $gcs::params::package_provider,
  $checksum         = $gcs::params::checksum,
  $download_package = $gcs::params::download_package,
  $download_url     = $gcs::params::download_url,
) inherits ::gcs::params {

  validate_re(
    $ensure,
    [ '^running$', '^stopped$' ],
    "${ensure} isn't supported. Valid values are 'running' and 'stopped'."
  )

  validate_re(
    $package_provider,
    [ '^dpkg$', '^rpm$' ],
    "${package_provider} isn't supported. Valid values are 'dpkg' and 'rpm'."
  )

  validate_re(
    $checksum_type,
    [ '^md5$', '^sha256$' ],
    "${checksum_type} isn't supported. Valid values are 'md5' and 'sha256'."
  )

  validate_re(
    $package_version,
    '^(\d)\.(\d)\.(\d)(-+.*)?$',
    'You must specify a package version in the semver format 0.1.0 or 0.1.0-beta.2'
  )

  validate_bool($enable,$manage_service,$tls_skip_verify,$send_status,$filebeat_enable,$nxlog_enable,$manage_cache_dir)
  validate_string($checksum,$download_url)
  validate_array($tags)
  validate_absolute_path($log_files,$conf_dir,$puppet_cache,$archive_dir,$download_package)
  validate_integer($update_interval)
  validate_integer($package_revision)

  if $server_url == undef {
    fail('server_url must be set!')
  } elsif !is_string($server_url) {
    fail("\$gcs::server_url must be a valid url like http://127.0.0.1:9000/api/")
  }

  anchor { '::gcs::begin': }
  -> class { '::gcs::install': }
  -> class { '::gcs::config': }
  ~> class { '::gcs::service': }
  anchor { '::gcs::end': }
}
