# io_portalwar::error_properties
#
# Add/modify entries in error.properties
#
# @summary This class will update the values in the
#     error.properties file for each domain/site
#
# @example
#   include io_portalwar::error_properties
class io_portalwar::error_properties (
  $ensure            = $io_portalwar::ensure,
  $pia_domain_list   = $io_portalwar::pia_domain_list,
  $error_properties  = $io_portalwar::error_properties,
) inherits io_portalwar {
  notify { 'Updating error.properties': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    $site_list   = $pia_domain_info['site_list']
    $site_list.each |$site_name, $site_info| {

        $config   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/${site_name}/error.properties"
        $properties = $error_properties[$domain_name][$site_name]
        $properties.each | $setting, $value | {

          ini_setting { "${domain_name}, ${site_name} ${setting} ${value}" :
            ensure  => present,
            path    => $config,
            section => '',
            setting => $setting,
            value   => $value,
          }
        }

    } # end site_list
  } # end pia_domain_list

}
