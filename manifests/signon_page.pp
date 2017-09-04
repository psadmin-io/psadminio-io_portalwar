# io_portalwar::signon
#
# Deploy custom signon pages to each PIA site
#
# @summary This class will take the list of pages defined in Hiera
#   and deploy them to each PIA site.
#
# @example
#   include io_portalwar::signon_page
class io_portalwar::signon_page (
  $ensure           = $io_portalwar::ensure,
  $pia_domain_list  = $io_portalwar::pia_domain_list,
  $portal_files     = $io_portalwar::portal,
  $source           = $io_portalwar::signon_page::source,
) inherits io_portalwar {
  notify { 'Deplying Custom Signon Pages': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $site_list       = $pia_domain_info['site_list']


    $site_list.each |$site_name, $site_info| {

      # Deploy files to PORTAL.war/site_name
      $site_portal = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/${site_name}"

      $portal_files["${domain_name}"].each | $file | {
        file {"{site_portal}/${file}":
          ensure => $ensure,
          source => $source,
        }
      }

      # Deploy files to PORTAL.war/WEB-INF/psftdocs/site_name
      $site_psftdocs = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/${site_name}"


    }
  }

}
