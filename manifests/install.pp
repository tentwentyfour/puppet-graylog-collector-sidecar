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

  $version_parts = "${::gcs::package_version}".match(/(\d)\.(\d)\.(\d)(-+.*)/)

  if !is_array($version_parts) {
    fail("There was a problem parsing the package_version ${::gcs::package_version}.")
  }

  $major_version = $version_parts[1]
  $minor_version = $version_parts[2]
  $patch_level   = $version_parts[3]
  $extra_level   = $version_parts[4]

  $download_url = $::osfamily ? {
    'debian' => "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${extra_level}/collector-sidecar_${major_version}.${minor_version}.${patch_level}-1_${::architecture}.deb",
    'redhat' => "https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${extra_level}/collector-sidecar-${major_version}.${minor_version}.${patch_level}-1.${::architecture}.rpm",
    default  => fail("${::osfamily} is not supported!"),
  }

  $package = $::osfamily ? {
    'debian' => "${::gcs::params::tmp_location}/collector-sidecar.${::gcs::package_version}.deb",
    'redhat' => "${::gcs::params::tmp_location}/collector-sidecar.${::gcs::package_version}.rpm",
    default  => fail("${::osfamily} is not supported!"),
  }

  if $::osfamily == 'debian' {
    Package { provider => 'dpkg', }
  }

  if $::osfamily == 'redhat' {
    Package { provider => 'rpm', }
  }

  # It would be better to compare a hash of the file to a newly downloaded one and replace
  # it, if necessary.
  exec { 'retrieve_gcs':
    command => "/usr/bin/wget -q ${download_url} -O ${package}",
    creates => "${package}",
  }->
  package { 'collector-sidecar':
    ensure => present,
    source => "${package}",
  }

}
