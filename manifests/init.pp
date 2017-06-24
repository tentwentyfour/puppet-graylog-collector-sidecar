# Class: gcs
# ===========================
#
# @summary The gcs module installs graylog collector-sidecar, manages its service and configuration.
#
# @example Declaring the class
#   { '::gcs': server_url => 'http://127.0.0.1:9000/api/' }
#   In hiera, you can set configuration variables:
#   gcs::server_url: http://my.graylog.server:9000/api
#   gcs::update_interval: 15
#   gcs::tags:
#     - linux
#     - icinga2
#     - nginx
#
# @param ensure Enum['running', 'stopped'] Whether the collector-service should be running or stopped.
#
# @param enable Boolean Whether to enable the collector-service.
#
# @param install_service Boolean Whether to install the collector-service.
#
# @param server_url String The URL to the API of your Graylog server.
#
# @param tags Array[String] The tags which are used to define which configurations the host should receive.
#
# @param package_version Enum['^(\d)\.(\d)\.(\d)(-+.*)?$'] Which package version to install.
#
# @param package_revision Integer[1] Which package version to install.
#
# @param log_files [Array[Stdlib::Absolutepath]] Send a directory listing to Graylog. This can also be a list of directories.
#
# @param update_interval Integer[1] The interval in seconds the sidecar will fetch new configurations from the Graylog server.
#
# @param tls_skip_verify Boolean Ignore errors when the REST API was started with a self-signed certificate.
#
# @param send_status Boolean Send the status of each backend back to Graylog and display it on the status page for the host.
#
# @param conf_dir [Stdlib::Absolutepath] Specify the configuration directory for collector-sidecar.
#
# @param service String The service name.
#
# @param filebeat_enable Boolean Whether to enable the filebeat service.
#
# @param nxlog_enable Boolean Whether to enable the nxlog service.
#
# @param manage_cache_dir Boolean Whether to create the archive directory for the downloaded package.
#
# @param puppet_cache [Stdlib::Absolutepath] The parent directory for the directory which holds the downloaded package.
#
# @param archive_dir [Stdlib::Absolutepath] The archives directory for the downloaded package.
#
# @param checksum_type Enum['md5', 'sha256'] The checksum type to validate the downloaded package.
#
# @param service_provider String The service provider to use.
#
# @param package_provider Enum['dpkg', 'rpm'] The package provider to use for installing collector-sidecar with a source parameter.
#
# @param checksum String The checksum of the downloaded package.
#
# @param download_package [Stdlib::Absolutepath] Set where to save the downloaded collector-sidecar package.
#
# @param download_url Optional[String] Provide your own URL from which the package will be downloaded.
#
# === Authors
#
# David Raison <david@tentwentyfour.lu>
#
class gcs (
  $ensure           = $gcs::params::ensure,
  $enable           = $gcs::params::enable,
  $install_service  = $gcs::params::install_service,
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

  validate_bool($enable,$install_service,$tls_skip_verify,$send_status,$filebeat_enable,$nxlog_enable,$manage_cache_dir)
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
