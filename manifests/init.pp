class io_portalwar (
  $ensure                    = hiera('ensure', 'present'),
  $psft_runtime_user_name    = hiera('psft_runtime_user_name', 'psadm2'),
  $oracle_install_group_name = hiera('oracle_install_group_name', 'oinstall'),
  $index_redirect            = hiera('index_redirect', false),
  $rename_pia_cookie         = hiera('rename_pia_cookie', false),
  $signon_page               = hiera('signon_page', false),
  $config_properties         = hiera('config_properties', false),
  $favicons                  = hiera('favicons', false),
  $text_properties           = hiera('text_properties', false),
  $redirect_target           = hiera('redirect_target', './ps/signon.html'),
  $pia_domain_list           = hiera('pia_domain_list', undef),
  $pia_cookie_name           = hiera('pia_cookie_name', undef),
  $configprop                = hiera('configprop', undef),
  $psserver_list             = hiera('psserver_list', undef),
) {

case $::osfamily {
    'AIX':     {
      $platform = 'AIX'
    }
    'Solaris': {
      $platform = 'SOLARIS'
    }
    'windows': {
      $platform = 'WIN'
    }
    default:   {
      $platform = 'LINUX'
    }
  }

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

  if ($config_properties) {
    contain ::io_portalwar::config_properties
  }

  if ($favicons) {
    contain ::io_portalwar::favicons
  }
}
