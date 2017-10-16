class io_portalwar (
  $ensure                    = ::io_portalwar::params::ensure,
  $pia_domain_list           = ::io_portalwar::params::pia_domain_list,
  $psft_runtime_user_name    = ::io_portalwar::params::psft_runtime_user_name,
  $oracle_install_group_name = ::io_portalwar::params::oracle_install_group_name,
  $index_redirect            = ::io_portalwar::params::index_redirect,
  $redirect_target           = ::io_portalwar::params::redirect_target,
  $pia_cookie_name           = ::io_portalwar::params::pia_cookie_name,
  $configprop                = ::io_portalwar::params::configprop,
  $psserver_list             = ::io_portalwar::params::psserver_list,
  $platform                  = ::io_portalwar::params::platform,
) inherits ::io_portalwar::params {

  validate_hash($pia_domain_list)

  #contain ::io_portalwar::configprop
  #contain ::io_portalwar::psserver_shuf

  if ($index_redirect) {
    contain ::io_portalwar::index_redirect
  }

  if ($rename_pia_cookie) {
    contain ::io_portalwar::cookie_name
  }
}
