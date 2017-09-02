class io_portalwar (
  $ensure                    = hiera('ensure', 'present'),
  $psft_install_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $domain_user               = hiera('domain_user', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list'),
  $index_redirect            = false,
  $redirect_target           = './ps/signon.html',
  $pia_cookie_name           = undef,
  $configprop                = undef,
  $psserver_list             = undef,
){

  #contain ::io_portalwar::configprop
  #contain ::io_portalwar::psserver_shuf
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

  if ($io_portalwar::index_redirect) {
    contain ::io_portalwar::index_redirect
  }

  if ($io_portalwar::rename_pia_cookie) {
    contain ::io_portalwar::cookie_name
  }

  if ($io_portalwar::signon_page) {
    contain ::io_portalwar::signon_page
  }
}
