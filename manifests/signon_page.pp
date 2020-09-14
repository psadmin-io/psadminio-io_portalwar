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
  $ensure                  = $io_portalwar::ensure,
  $pia_domain_list         = $io_portalwar::pia_domain_list,
  $source                  = $io_portalwar::source,
  $signon_page             = $io_portalwar::signon_page,
  $psft_runtime_user_name  = $io_portalwar::psft_runtime_user_name,
  $psft_runtime_group_name = $io_portalwar::psft_runtime_group_name,
) inherits io_portalwar {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    # notify { "Config Home: ${ps_cfg_home_dir}": }
    $files           = $signon_page[$domain_name]
    if ($files) {
      notify { "Files to deploy: ${files}": }

      $portalwar = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war"
      if ($files['root']) {
        notify { "Deplying Custom Signon Pages - ${domain_name} Root": }

        $files['root'].each | $file | {

          file {"${portalwar}/${file}":
            ensure => $ensure,
            source => "${source}/${file}",
            owner  => $psft_runtime_user_name,
            group  => $psft_runtime_group_name,
            mode   => '0644',
          }
        }
      }
    } else {
      notify { "${domain_name} No root custom files to deploy": }
    } # end of 'root'

    $site_list   = $pia_domain_info['site_list']
    if ($site_list) {
      $site_list.each |$site_name, $site_info| {

        # Deploy files to PORTAL.war/site_name
        $site_portal = "${portalwar}/${site_name}"
        $site_psftdocs = "${portalwar}/WEB-INF/psftdocs/${site_name}"

        # Check if io_portalwar::signon_page has this site listed
        if ($site_name in $files) {

          if ($files[$site_name]['portal']) {
            notify { "Deplying Custom Signon Pages - ${domain_name}-${site_name} Portal": }

            $files[$site_name]['portal'].each | $file | {

              file {"${site_portal}/${file}":
                ensure => $ensure,
                source => "${source}/${file}",
                owner  => $psft_runtime_user_name,
                group  => $psft_runtime_group_name,
                mode   => '0644',
              }
            }
          } else {
            notify { "${domain_name} ${site_name} No portal custom files to deploy": }
          } # end if 'portal'

          if ($files[$site_name]['psftdocs']) {
            notify { "Deplying Custom Signon Pages - ${domain_name}-${site_name} psftdocs": }

            $files[$site_name]['psftdocs'].each | $file | {

              file {"${site_psftdocs}/${file}":
                ensure => $ensure,
                source => "${source}/${file}",
                owner  => $psft_runtime_user_name,
                group  => $psft_runtime_group_name,
                mode   => '0644',
              }
            }
          }  else {
            notify { "${domain_name} ${site_name} No psftdocs custom files to deploy": }
          } # end if 'psftdocs'
        } # has_key $site_name

      } # end site_list
    } # if site_list

  } # end pia_domain_list

}
