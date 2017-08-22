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
  $ensure                    = $io_portalwar::params::ensure,
  $pia_domain_list           = $io_portalwar::params::pia_domain_list,
  $redirect_target           = $io_portalwar::params::redirect_target,
  $psft_runtime_user_name    = $io_portalwar::params::psft_runtime_user_name,
  $oracle_install_group_name = $io_portalwar::params::oracle_install_group_name,
) inherits io_portalwar::params {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    $index = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/index.html"

    notify { $index : }
    notify { $domain_name : }

    file { $index :
      ensure  => file,
      content => template('io_portalwar/index.html.erb'),
      owner   => $psft_runtime_user_name,
      group   => $psft_runtime_group_name,
      mode    => '0644',
    }
  }
}
