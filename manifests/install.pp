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

  $tmp_location = '/tmp'
  $package  = "${tmp_location}/graylog-collector-sidecar.${::gcs::package_version}.deb"

  if $module_name != $caller_module_name {
    fail("gcs::install is a private class of the module gcs, you're not permitted to use it.")
  }

  if $::osfamily == 'debian' {
    Package { provider => 'dpkg', }
  }

  file { 'package_file':
    path   => $package,
    ensure => absent,
  }->
  exec { 'retrieve_gcs':
    command => "/usr/bin/wget -q ${::gcs::download_url} -O ${package}",
    creates => "${package}",
  }->
  package { 'graylog-collector-sidecar':
    ensure => present,
    source => "${package}",
  }

}
