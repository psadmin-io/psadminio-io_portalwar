# io_portalwar::config_properties
#
# Take a hash of potential configuration.properties settings and write them to the file
#
# This class is to allow the setting of arbitrary settings in configuration.properties
# Some use cases:
# 1. Set WebUserID, which the installer forces to PTWEBSERVER regardless of input
# 2. Set the Web Profile after install as the installer does not accept custom values
#
# @example
#   include io_portalwar::config_properties
class io_portalwar::config_properties (
  $pia_domain_list   = $io_portalwar::pia_domain_list,
  $config_properties = $io_portalwar::config_properties,
){

  notify { 'Updating configuration.properties': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    $properties = $config_properties[$domain_name]
    $site_list   = $pia_domain_info['site_list']
    if ($site_list) {
      $site_list.each |$site_name, $site_info| {

          $config   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/${site_name}/configuration.properties"
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
    }
  } # end pia_domain_list
}

