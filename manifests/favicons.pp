# io_portalwar::favicons
#
# Deploy a favicons.zip to the root directory
#
# @summary This class will copy a favicons.zip file
#    to the root directory of PORTAL.war and 
#    exctract the zip file
#
# @example
#   include io_portalwar::favicons
class io_portalwar::favicons (
  $ensure                   = $io_portalwar::ensure,
  $pia_domain_list          = $io_portalwar::pia_domain_list,
  $source                   = $io_portalwar::source,
  $favicons_archive         = $io_portalwar::favicons_archive,
  $extract_command          = $io_portalwar::extract_command,
  $fileowner                = $io_portalwar::fileowner,
  $oracle_install_user_name = $io_portalwar::oracle_install_user_name,
) inherits io_portalwar {
  notify { 'Deplying favicons.zip': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $root_folder   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/"

    file {"${root_folder}/favicons.zip":
      source => "${source}/${favicons_archive}",
    }
    -> archive {"Extract favicons.zip ${domain_name}":
      ensure          => $ensure,
      user            => $fileowner,
      group           => $oracle_install_user_name,
      extract         => true,
      source          => "${source}/${favicons_archive}",
      extract_path    => $root_folder,
      extract_command => "${extract_command}${root_folder}",
      creates         => "${root_folder}/favicon.ico",
      cleanup         => true,
    }

  } # end pia_domain_list

}
