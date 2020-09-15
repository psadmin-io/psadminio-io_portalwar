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
  $favicons                 = $io_portalwar::favicons,
  $extract_command          = $io_portalwar::extract_command,
  $fileowner                = $io_portalwar::fileowner,
  $psft_runtime_group_name  = $io_portalwar::psft_runtime_group_name,
) inherits io_portalwar {
  notify { 'Deplying favicons.zip': }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']


    $site_list   = $pia_domain_info['site_list']
    $site_list.each |$site_name, $site_info| {
      $root_folder   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/${site_name}"

      file {"${root_folder}/favicons.zip":
        source => "${source}/${favicons}",
      }
      -> archive {"Extract favicons.zip ${domain_name} ${site_name}":
        ensure          => $ensure,
        user            => $fileowner,
        group           => $psft_runtime_group_name,
        extract         => true,
        source          => "${source}/${favicons}",
        extract_path    => $root_folder,
        extract_command => "${extract_command}${root_folder}",
        creates         => "${root_folder}/apple-touch-icon.png",
        cleanup         => true,
      }
    }

  } # end pia_domain_list

}
