
# io_portalwar

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with io_portalwar](#setup)
    * [What io_portalwar affects](#what-io_portalwar-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with io_portalwar](#beginning-with-io_portalwar)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module is used to configure various settings in the WebLogic Domain servlet PORTAL.war for Peoplesoft to complement the DPK.

## Setup

### Setup Requirements

This module has a requirement of the puppetlabs/inifile module. https://forge.puppet.com/puppetlabs/inifile

If you are using PeopleTools 8.55, that version of Puppet will need version 1.6.0 of the `inifile` module.

### Beginning with io_portalwar  

Add `contain ::io_portalwar` to a delivered or custom DPK profile. To change defaults, see usage below.

## Usage

This module will use data from your yaml files. It uses delivered DPK hashes/variables, as well as `io_portalwar` specific hashes/variables you will want to add.

### Custom Signon Page

```yaml
io_portalwar::source: "/tmp/"
io_portalwar::signon_page:
  "%{hiera('pia_domain_name')}":
    root:
      - logo.png
    "%{hiera('pia_site_name')}":
      portal:
        - bootstrap.min.css
        - bootstrap.min.js
        - bootstrap-theme.min.css
        - logo.png
      psftdocs:
        - custom.html
        - custom.js
        - logo.png
```

The `io_portalwar::source` value is used for all the files. 

* The `root` array is for files to be deployed under the `PORTAL.war` folder. 
* The `portal` array is for files to be deployed under the `PORTAL.war\site_name` folder.
* The `psftdocs` array is for files to be deployed under the `PORTAL.war\WEB-INF\psftdocs\site_name` folder.

### Configuration.properties

```yaml
io_portalwar::config_properties:
  "%{hiera('pia_domain_name')}":
    "%{hiera('pia_site_name')}":
      WebProfile: EXTERNAL
```

### Text.properties

```yaml
io_portalwar::text_properties:
  "%{hiera('pia_domain_name')}":
    "%{hiera('pia_site_name')}":
      '138':  'Signon to the Test Environment'
      '8998': 'Custom Message'
```
### Error.properties

```yaml
io_portalwar::error_properties:
  "%{hiera('pia_domain_name')}":
    "%{hiera('pia_site_name')}":
      '105':  'Your User ID or Password is invalid.'
```

### Rename the Cookie

```yaml
io_portalwar::rename_pia_cookie: true
io_portalwar::pia_cookie_name: "%{hiera('db_name')}-PORTAL-PSJSESSIONID"
```

### index.html Redirect

```yaml
io_portalwar::index_redirect: true
io_portalwar::redirect_target: "./%{hiera('pia_site_name')}/signon.html"
```

### Favicons

```yaml
# You can source files from an OS path, or from another Puppet module
# Source is used for favicons and Signon Page features
# this expects a favicon.zip file in the source directory
io_portalwar::source: 'puppet:///modules/io_deploy' 
io_portalwar::favicons: true
```

### Signon Page Changes

```yaml
# You can source files from an OS path, or from another Puppet module
# Source is used for favicons and Signon Page features
io_portalwar::source: 'puppet:///modules/io_deploy' 
io_portalwar::signon_page:
  "%{hiera('db_name')}":
    root:
      - robots.txt
    "%{hiera('pia_site_name')}":
      portal:
        - logo.png
      psftdocs:
        - signon.html
```
