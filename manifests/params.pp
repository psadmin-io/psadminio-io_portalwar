class io_portalwar::params {
  $ensure                    = 'present'
  $index_redirect            = false
  $rename_pia_cookie         = false
  $signon_page               = false
  $config_properties         = false
  $favicons                  = false
  $text_properties           = false
  $error_properties          = false
  $redirect_target           = './ps/signon.html'
  $pia_domain_list           = hiera_hash('pia_domain_list')
  $pia_cookie_name           = undef
  $configprop                = undef
  $psserver_list             = undef
  $source                    = undef

  case $::osfamily {
    'AIX':     {
      $platform = 'AIX'
      $psft_runtime_user_name    = 'psadm1'
      $oracle_install_group_name = 'oinstall'
    }
    'Solaris': {
      $platform = 'SOLARIS'
      $psft_runtime_user_name    = 'psadm1'
      $oracle_install_group_name = 'oinstall'
    }
    'windows': {
      $platform = 'WIN'
      $psft_runtime_user_name = hiera('domain_user')
      $oracle_install_group_name = 'S-1-5-32-544' #administrators
    }
    default:   {
      $platform = 'LINUX'
      $psft_runtime_user_name    = 'psadm2'
      $oracle_install_group_name = 'oinstall'
    }
  }
}
