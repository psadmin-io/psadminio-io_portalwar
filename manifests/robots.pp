# io_portalwar::robots
#
# Deploy a robots.txt file to stop search index crawling
#
# @summary Deploy a robots.txt file to stop search indexes
# from crawling the PeopleSoft site. The file will set a 
# default block for all pages.
#
# @example
#   include io_portalwar::robots
class io_portalwar::robots (
  $ensure                    = $io_portalwar::ensure,
  $pia_domain_list           = $io_portalwar::pia_domain_list,
  $robots                    = $io_portalwar::robots,
  $fileowner                 = $io_portalwar::fileowner,
  $psft_runtime_user_name    = $io_portalwar::psft_runtime_user_name,
  $oracle_install_group_name = $io_portalwar::oracle_install_group_name,
) inherits io_portalwar {
  notify { 'Deplying robots.txt file': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $root_folder   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war"

    file {"${root_folder}/robots.txt":
      ensure  => file,
      content => template('io_portalwar/robots.txt.erb'),
      owner   => $psft_runtime_user_name,
      group   => $oracle_install_group_name,
      mode    => '0644',
    }

  } # end pia_domain_list

}



