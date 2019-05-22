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
  $source           = $io_portalwar::source,
  $signon_page      = $io_portalwar::signon_page,
) inherits io_portalwar {
  
    $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    # notify { "Config Home: ${ps_cfg_home_dir}": }
    $files           = $signon_page["${domain_name}"]
    # notify { "Files to deploy: ${files}": }


    $portalwar = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war"
    if ($files['root']) {
      $files['root'].each | $file | {

        notify { 'Deplying Custom Signon Pages - Root': }

        file {"${portalwar}/${file}":
          ensure => $ensure,
          source => "${source}/${file}",
          owner  => $psft_runtime_user_name,
          group  => $psft_runtime_group_name,
          mode   => '0644',
        }
      }
    } else {
      # notify { "${domain_name} No root custom files to deploy": }
    } # end of 'root'

    $site_list   = $pia_domain_info['site_list']
    $site_list.each |$site_name, $site_info| {

      # Deploy files to PORTAL.war/site_name
      $site_portal = "${portalwar}/${site_name}"
      $site_psftdocs = "${portalwar}/WEB-INF/psftdocs/${site_name}"

      if ($files['portal']) {
        $files['portal'].each | $file | {

          notify { 'Deplying Custom Signon Pages - Portal': }

          file {"${site_portal}/${file}":
            ensure => $ensure,
            source => "${source}/${file}",
            owner  => $psft_runtime_user_name,
            group  => $psft_runtime_group_name,
            mode   => '0644',
          }
        }
      } else {
        # notify { "${domain_name} ${site_name} No portal custom files to deploy": }
      } # end if 'portal'

      if ($files['psftdocs']) {
        $files['psftdocs'].each | $file | {

          notify { 'Deplying Custom Signon Pages - psftdocs': }

          file {"${site_psftdocs}/${file}":
            ensure => $ensure,
            source => "${source}/${file}",
            owner  => $psft_runtime_user_name,
            group  => $psft_runtime_group_name,
            mode   => '0644',
          }
        }
      }  else {
        # notify { "${domain_name} ${site_name} No psftdocs custom files to deploy": }
      } # end if 'psftdocs'

    } # end site_list
  } # end pia_domain_list

}
