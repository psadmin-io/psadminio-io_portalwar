
# io_portalwar

#### Table of Contents

- [io_portalwar](#io_portalwar)
      - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Setup Requirements](#setup-requirements)
    - [Beginning with io_portalwar](#beginning-with-io_portalwar)
  - [Usage](#usage)
    - [Custom Signon Page](#custom-signon-page)
    - [Configuration.properties](#configurationproperties)
    - [Text.properties](#textproperties)
    - [Error.properties](#errorproperties)
    - [Rename the Cookie](#rename-the-cookie)
    - [index.html Redirect](#indexhtml-redirect)
    - [Favicons](#favicons)
    - [Health Check File](#health-check-file)
    - [Host Information File](#host-information-file)
    - [robots.txt](#robotstxt-file)
    - [Remove PSEMHUB](#remove-psemhub)

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

### Health Check File

This will create a `health.html` file under `PORTAL.war` that you can use with your load balancer health check. The string value in the `io_portalwar::healthcheck` variable will be added the content of the file.

```yaml
io_portalwar::healthcheck: 'up'
```

### Host Information File

Setting this value will create a file under `PORTAL.war` that sets `hostname-domainname` as the content. This can be used to validate which server a user is connected to in a load balanced environment. The name of the file is configured by enabling the feature and adding `.html` to the name. In the example below, the feature will create `PORTAL.war\hostinfo.html`

```yaml
io_portalwar::hostinfo: 'hostinfo'
```

### robots.txt File

You can deploy a robots.txt that will stop search indexes from crawling your PeopleSoft site's files. This is a good way to keep public pages from showing up in search results. It does not block access to the pages, it's a request to search indexes (like Google) to stop them from indexing your site.

```yaml
io_portalwar::robots: true
```
### Remove PSEMHUB

Removes the Environment Management Hub (`PSEMHUB`) web module from the
deployed PeopleSoft EAR. This implements Oracle's documented fix for
**CVE-2026-35273** (Oracle Security Alert, June 2026 — CVSS 9.8,
remotely exploitable without authentication, component: PeopleTools
Updates - Environment Management, affecting 8.61 and 8.62) for single
server PIA domains:

1. Removes the `PSEMHUB` `<module>` entry from
   `applications/peoplesoft/META-INF/application.xml`
2. Removes the exploded `applications/peoplesoft/PSEMHUB.war` folder

```yaml
io_portalwar::remove_psemhub: true
```

Notes:

* Linux, single server PIA domains only. For multi-server domains with
  a dedicated `PSEMHUB` managed server, stop/disable that managed
  server instead of using this feature.
* A PIA bounce is required for the change to take effect on a running
  domain: stop PIA, run Puppet, start PIA.
* PIA redeploys and PeopleTools patches will restore `PSEMHUB`.
  Re-running with this flag set re-removes it, which is what makes the
  mitigation DPK-durable.
* EMF is only used by Change Assistant/PUM crawl-and-apply cycles.
  Leave this feature disabled on the environment you actually run
  Change Assistant against, and remove the hub everywhere else.

To apply ad hoc without a full DPK run:

```bash
$PS_CFG_HOME/webserv/<domain>/bin/stopPIA.sh

puppet apply --confdir $DPK_HOME/puppet \
  -e "class { '::io_portalwar': remove_psemhub => true }"

$PS_CFG_HOME/webserv/<domain>/bin/startPIA.sh
```

Declare the parent class (not `io_portalwar::psemhub` alone) so
`pia_domain_list` and related values resolve from hiera.
