# io_portalwar::hostinfo
#
# Deploy a {hostinfo}.html file for load balancers
#
# @summary This class will deploy a file to be used 
# for validating which host a user is on in a 
# load balanced environment
#
# @example
#   include io_portalwar::hostinfo
class io_portalwar::hostinfo (
  $ensure                    = $io_portalwar::ensure,
  $pia_domain_list           = $io_portalwar::pia_domain_list,
  $hostinfo                  = $io_portalwar::hostinfo,
  $fileowner                 = $io_portalwar::fileowner,
  $psft_runtime_user_name    = $io_portalwar::psft_runtime_user_name,
  $oracle_install_group_name = $io_portalwar::oracle_install_group_name,
) inherits io_portalwar {
  notify { 'Deplying host information file': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $root_folder   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war"

    $content = "${::hostname}-${domain_name}"

    file {"${root_folder}/${hostinfo}.html":
      content => $content,
      owner   => $psft_runtime_user_name,
      group   => $oracle_install_group_name,
      mode    => '0644',
    }

  } # end pia_domain_list

}
