# io_portalwar::psserver_shuf
#
# Take an array of appserver hostnames, combine with JOLT port and shuffle the list
#
# The Failover for PeopleSoft application servers from webservers works by selecting a
# random server from the psserver= list in configuration.properties. If the selected 
# server is non-responsive, the NEXT server in psserver= is used. If an appserver is lost,
# This pattern results in the next server in the list recieivng a disproportionate share 
# of the system load. To workaround this, we randomize the order of servers in the psserver=
# so that the "next" server is not consistent accross all web server configs.
#
# @example
#   include io_portalwar::psserver_shuf
class io_portalwar::psserver_shuf (
  $pia_domain_list = $io_portalwar::params::pia_domain_list,
  $configprop      = $io_portalwar::params::config_prop,
  $psserver_list   = $io_portalwar::params::psserver_list,
){

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $site_list       = $pia_domain_info['site_list']

    $site_list.each |$site_name, $site_info| {

      $config   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/${site_name}/configuration.properties"
      $defaults = { 'path' => "${config}" }

      if $cu_pia_psserver_list != undef {

        $appsrv_psserver_jolt = $psserver_list[$domain_name][$site_name].map |$s1| { "${s1}:${jolt_port}" }
        $appsrv_psserver_shuf = join(shuffle($appsrv_psserver_jolt),',')

        ini_setting { "${domain_name}, ${site_name} shuffle psserver" :
          ensure  => present,           
          path    => $config,           
          section => '',                
          setting => 'psserver',        
          value   => $appsrv_psserver_shuf,
        }
      }
    }
  }
}
