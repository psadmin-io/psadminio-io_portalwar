class io_portalwar (
) inherits io_portalwar::params {

  #contain ::io_portalwar::configprop
  #contain ::io_portalwar::psserver_shuf

  if ($io_portalwar::params::index_redirect) {
    contain ::io_portalwar::index_redirect
  }

  if ($io_portalwar::params::rename_pia_cookie) {
    contain ::io_portalwar::cookie_name
  }
}
