# io_portalwar::cookie_name
#
# Replace the cookie-name entry in weblogic.xml for PeopleSoft
#
# Allow an organization to set the PeopleSoft session cookie
# to their own standard.
#
# @example
#   include io_portalwar::cookie_name

class io_portalwar::cookie_name (
  $pia_domain_list = $io_portalwar::params::pia_domain_list,
  $pia_cookie_name = $io_portalwar::params::pia_cookie_name,
) inherits io_portalwar::params {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    if (!$pia_cookie_name) {
      $pia_cookie_name = "${domain_name}-PSJSESSIONID"
    }

    notify { "domain: ${domain_name}" :}

    augeas { "${domain_name} weblogic.xml cookie-name" :
      lens    => 'Xml.lns',
      incl    => "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/weblogic.xml",
      context => "/files/${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/weblogic.xml/weblogic-web-app/session-descriptor/cookie-name",
      changes => "set #text ${pia_cookie_name}",
    }
  }
}
