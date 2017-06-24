# Graylog Collector Sidecar Module

Installs and configures the collector-sidecar package for graylog. [![Build Status](https://travis-ci.org/tentwentyfour/puppet-graylog-collector-sidecar.svg?branch=master)](https://travis-ci.org/tentwentyfour/puppet-graylog-collector-sidecar)


#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with graylog-collector-sidecar](#setup)
    * [What graylog-collector-sidecar affects](#what-graylog-collector-sidecar-affects)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module can be used to install and configure the Graylog Collector Sidecar. (http://docs.graylog.org/en/2.2/pages/collector_sidecar.html)

## Setup

Since this module has not been published to puppetforge yet, include its git repository in your Puppetfile:

```
mod 'gcs',
    git: 'https://github.com/tentwentyfour/puppet-graylog-collector-sidecar.git',
    ref: '0.4.0'
```

### What graylog-collector-sidecar affects

The graylog-collector-sidecar module manages the following things:

* Graylog-collector-sidecar packages
* Graylog-collector-sidecar configuration file
* Graylog-collector-sidecar service

### Setup requirements

The module requires puppetlabs-stdlib and puppetlabs-apt on Debian-based OSs.

## Usage

You can configure the module using hiera:

```
include ::gcs
```

```yaml
gcs::server_url: http://my.graylog.server:9000/api
gcs::update_interval: 15
gcs::tags:
  - linux
  - icinga2
  - nginx
```

The same can be achieved using puppet manifests only:

```
class { '::gcs':
    update_interval => 10,
    server_url      => 'http://my.graylog.server:9000/api',
    tags            => [
       'linux',
       'icinga2',
       'nginx',
    ],
}
```

## Reference

- [**Public classes**](#public-classes)
    - [Class: gcs](#class-gcs)
- [**Private classes**](#private-classes)
    - [Class: gcs::params](#class-gcs-params)
    - [Class: gcs::config](#class-gcs-config)
    - [Class: gcs::service](#class-gcs-service)

### Public classes

#### Class: `gcs`

The default class of this module. It handles the basic installation and configuration of Graylog Collector Sidecar.
When you declare this class, puppet will do the following:

* Install Graylog Collector Sidecar
* Place a default configuration for the Collector-Sidecar daemon
* Start collector-sidecar and enable the service

This class requires that you set the server_url parameter. All other parameters are optional.

``` puppet
class { 'gcs':
    server_url => 'https://my.graylog.server/api',
}
```

**Parameters within `gcs`**

##### `ensure`
Valid values are running or stopped. Default: running

##### `enable`
Whether to enable the collector-sidecar service. Default: true

##### `install_service`
Whether or not to install the collector-sidecar service. Default: true

##### `server_url`
URL to the api of your graylog server. Collector-sidecar will fetch configurations from this host based on the configured tags. Default: undef

##### `tags`
Tags for this host. Default: []

##### `package_version`
Which package version to install. Default: 0.1.0

##### `package_revision`
Which package revision to install. Default: 1 (For most versions there is only one revision.)

##### `log_files`
Location of log files to index and report to the Graylog server. Default: ['/var/log']

##### `update_interval`
The interval in seconds the sidecar will fetch new configurations from the Graylog server. Default: 10.

##### `tls_skip_verify`
Ignore errors when the REST API was started with a self-signed certificate. Default: false

##### `send_status`
Send the status of each backend back to Graylog and display it on the status page for the host. Default: false

##### `conf_dir`
Specify the configuration directory for collector-sidecar. Default: /etc/graylog/collector-sidecar

##### `service`
Specify the service name for collector-sidecar. Default: collector-sidecar

##### `filebeat_enable`
Whether to enable the filebeat service. Default: true

##### `nxlog_enable`
Whether to enable the nxlog service. Default: false

##### `manage_cache_dir`
Whether to create the archive directory for the downloaded package. Default: true

##### `puppet_cache`
Specify the archives directory parent directory. Default: /var/cache/puppet

##### `archive_dir`
Specify the archives directory. Default: "${puppet_cache}/archives"

##### `checksum_type`
Specify the checksum type. Default: 'sha256'

##### `service_provider`
Service provider to use. Default: Depends on your operating system.

- **Ubuntu 15.04**: `upstart`
- **Ubuntu 16.04**: `systemd`
- **Debian**: `systemd`
- **Red Hat**: `systemd`
- **CentOS**: `systemd`

##### `package_provider`
Package provider to use. Default: Depends on your operating system family.

- **Debian**: `dpkg`
- **Red Hat**: `rpm`

##### `checksum`
Specify the checksum of the downloaded package. Default: Depends on your operating system.

##### `download_package`
Specify where to download the collector-sidecar package. Default: Depends on your operating system family.

- **Debian**: `${archive_dir}/collector-sidecar.${package_version}.deb`
- **Red Hat**: `${archive_dir}/collector-sidecar.${package_version}.rpm`

##### `download_url`
The URL from which the package will be downloaded. Default: Depends on your operating system family.

- **Debian**: `https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar_${major_version}.${minor_version}.${patch_level}${version_suffix}-${package_revision}_${::architecture}.deb`
- **Red Hat**: `https://github.com/Graylog2/collector-sidecar/releases/download/${major_version}.${minor_version}.${patch_level}${version_suffix}/collector-sidecar-${major_version}.${minor_version}.${patch_level}${version_suffix}-${package_revision}.${::architecture}.rpm`

### Private classes

Todo

## Limitations

- Currently only supports Beats (filebeat) backend.
- Only supports Debian (and derivates, e.g. Ubuntu) as well as RedHat (and derivates, e.g. CentOS)

## Development

Pull requests are welcome, especially those adding specs, further OS compatibility and documentation.
