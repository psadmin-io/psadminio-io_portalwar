class io_portalwar (
  $ensure                    = $::io_portalwar::params::ensure,
  $pia_domain_list           = $::io_portalwar::params::pia_domain_list,
  $psft_runtime_user_name    = $::io_portalwar::params::psft_runtime_user_name,
  $psft_runtime_group_name   = $::io_portalwar::params::psft_runtime_group_name,
  $index_redirect            = $::io_portalwar::params::index_redirect,
  $redirect_target           = $::io_portalwar::params::redirect_target,
  $pia_cookie_name           = $::io_portalwar::params::pia_cookie_name,
  $configprop                = $::io_portalwar::params::configprop,
  $psserver_list             = $::io_portalwar::params::psserver_list,
  $platform                  = $::io_portalwar::params::platform,
  $signon_page               = $::io_portalwar::params::signon_page,
  $text_properties           = $::io_portalwar::params::text_properties,
  $error_properties          = $::io_portalwar::params::error_properties,
  $config_properties         = $::io_portalwar::params::config_properties,
  $favicons                  = $::io_portalwar::params::favicons,
  $rename_pia_cookie         = $::io_portalwar::params::rename_pia_cookie,
  $source                    = $::io_portalwar::params::source,
) inherits ::io_portalwar::params {

  validate_hash($pia_domain_list)

  #contain ::io_portalwar::psserver_shuf

  if ($index_redirect) {
    contain ::io_portalwar::index_redirect
  }

  if ($rename_pia_cookie) {
    contain ::io_portalwar::cookie_name
  }

  if ($signon_page) {
    contain ::io_portalwar::signon_page
  }

  if ($config_properties) {
    contain ::io_portalwar::config_properties
  }

  if ($text_properties) {
    contain ::io_portalwar::text_properties
  }

  if ($error_properties) {
    contain ::io_portalwar::error_properties
  }

  if ($favicons) {
    contain ::io_portalwar::favicons
  }
}
