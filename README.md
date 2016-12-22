# Graylog Collector Sidecar Module

Installs and configures the collector-sidecar package for graylog.


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

This module can be used to install and configure the Graylog Collector Sidecar. (http://docs.graylog.org/en/2.1/pages/collector_sidecar.html)

## Setup

Since this module has not been published to puppetforge yet, include its git repository in your Puppetfile:

```
mod 'gcs',
    git: 'https://github.com/tentwentyfour/puppet-graylog-collector-sidecar.git',
    ref: '0.1.0'
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

The same can be achieved using puppe manifests only:

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
Valid values are running or stopped.

##### `enable`
Whether to enable the collector-sidecar service.

##### `manage_service`
Whether or not to manage (install, launch/stop) the collector-sidecar service.

##### `download_url`
URL to download package from.
By default, the package is downloaded from the graylog collector github release page.

##### `package_version`
Which package version to install.

##### `server_url`
URL to the api of your graylog server. Collector-sidecar will fetch configurations.
from this host based on the configured tags.

##### `tags`
Tags for this host

##### `log_files`
Location of log files to index and report to the Graylog server.

##### `update_interval`
The interval in seconds the sidecar will fetch new configurations from the Graylog server.
Default is set to 10 in params.

##### `tls_skip_verify`
Ignore errors when the REST API was started with a self-signed certificate.

##### `send_status`
Send the status of each backend back to Graylog and display it on the status page for the host.


### Private classes

TDB

## Limitations

- Currently only supports Beats (filebeat) backend and only Debian-based OSs.
- Missing specs!
- Package versions are not fully configurable yet.

## Development

Pull requests are welcome, especially those adding specs, further OS compatibility and documentation.