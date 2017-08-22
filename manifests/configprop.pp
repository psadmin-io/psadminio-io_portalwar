# io_portalwar::configprop
#
# Take a hash of potential configuration.properties settings and write them to the file
#
# This class is to allow the setting of arbitrary settings in configuration.properties
# Some use cases:
# 1. Set WebUserID, which the installer forces to PTWEBSERVER regardless of input
# 2. Set the Web Profile after install as the installer does not accept custom values
#
# @example
#   include io_portalwar::configprop
class io_portalwar::configprop (
  $pia_domain_list = $io_portalwar::params::pia_domain_list,
  $configprop      = $io_portalwar::params::config_prop,
  $psserver_list   = $io_portalwar::params::psserver_list,
){

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $site_list       = $pia_domain_info['site_list']

    $site_list.each |$site_name, $site_info| {

      $config   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/${site_name}/configuration.properties"

      $defaults = {
        'path'    => "${config}",
        'section' => '',
      }

      create_ini_settings($configprop[$domain_name][$site_name],  $defaults)
    }
  }
}
