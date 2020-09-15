# io_portalwar::index_redirect
#
# Update delivered PORTAL.war index.html with a new redirect target
#
# Allow PeopleSoft customers to replace the delivered WebLogic login/console
# Selection page with an automatic redirect
#
# @example
#   include io_portalwar::index_redirect
class io_portalwar::index_redirect (
  $ensure                    = $io_portalwar::ensure,
  $pia_domain_list           = $io_portalwar::pia_domain_list,
  $redirect_target           = $io_portalwar::redirect_target,
  $psft_runtime_user_name    = $io_portalwar::psft_runtime_user_name,
  $psft_runtime_group_name   = $io_portalwar::psft_runtime_group_name,
) {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    # notify {"Config settings for ${domain_name}: ${pia_domain_info}":}
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    $index = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/index.html"

    file { $index :
      ensure  => file,
      content => template('io_portalwar/index.html.erb'),
      owner   => $psft_runtime_user_name,
      group   => $psft_runtime_group_name,
      mode    => '0644',
    }
  }
}
