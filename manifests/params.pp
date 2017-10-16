class io_portalwar::params (
  $ensure                    = hiera('ensure', 'present'),
  $pia_domain_list           = hiera_hash('pia_domain_list'),
  $psft_runtime_user_name    = hiera('psft_install_user_name'),
  $oracle_install_group_name = hiera('oracle_install_group_name'),
  $index_redirect            = false,
  $redirect_target           = './ps/signon.html',
  $pia_cookie_name           = undef,
  $configprop                = undef,
  $psserver_list             = undef,
){

  case $::facts['os']['name'] {
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

}
