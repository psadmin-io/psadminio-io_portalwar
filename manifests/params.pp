class io_portalwar::params {
  $ensure                    = 'present'
  $index_redirect            = undef
  $rename_pia_cookie         = undef
  $signon_page               = undef
  $config_properties         = undef
  $favicons                  = undef
  $text_properties           = undef
  $error_properties          = undef
  $redirect_target           = './ps/signon.html'
  $pia_domain_list           = hiera_hash('pia_domain_list')
  $pia_cookie_name           = undef
  $configprop                = undef
  $psserver_list             = undef
  $source                    = undef
  $psft_runtime_user_name    = hiera('psft_runtime_user_name', 'psadm2')
  $psft_install_user_name    = hiera('psft_install_user_name', 'psadm1')
  $oracle_install_group_name = hiera('oracle_install_group_name', 'oinstall')

  case $::osfamily {
    'AIX':     {
      $platform = 'AIX'
      $psft_runtime_user_name    = 'psadm1'
      $psft_runtime_group_name = 'oinstall'
    }
    'Solaris': {
      $platform = 'SOLARIS'
      $psft_runtime_user_name    = 'psadm1'
      $psft_runtime_group_name = 'oinstall'
    }
    'windows': {
      $platform = 'WIN'
      $psft_runtime_user_name = hiera('domain_user')
      $psft_runtime_group_name = 'S-1-5-32-544' #administrators
    }
    default:   {
      $platform = 'LINUX'
      $psft_runtime_user_name    = 'psadm2'
      $psft_runtime_group_name = 'oinstall'
    }
  }
}
