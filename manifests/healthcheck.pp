# io_portalwar::healthcheck
#
# Deploy a health.html file for load balancers
#
# @summary This class will copy a health.html file
#    to the root directory of PORTAL.war and 
#    put a string value in the file
#
# @example
#   include io_portalwar::healthcheck
class io_portalwar::favicons (
  $ensure                   = $io_portalwar::ensure,
  $pia_domain_list          = $io_portalwar::pia_domain_list,
  $healthcheck              = $io_portalwar::healthcheck,
  $fileowner                = $io_portalwar::fileowner,
  $psft_runtime_group_name  = $io_portalwar::psft_runtime_group_name,
) inherits io_portalwar {
  notify { 'Deplying health.html': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $root_folder   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war"

    file {"${root_folder}/health.html":
      content => $healthcheck,
    }

  } # end pia_domain_list

}
