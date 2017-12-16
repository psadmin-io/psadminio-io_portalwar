class io_portalwar::params {
  $ensure                    = 'present'
  $psft_runtime_user_name    = 'psadm1'
  $oracle_install_group_name = 'oinstall'
  $index_redirect            = false
  $redirect_target           = './ps/signon.html'
  $pia_domain_list           = undef
  $pia_cookie_name           = undef
  $configprop                = undef
  $psserver_list             = undef

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
}
