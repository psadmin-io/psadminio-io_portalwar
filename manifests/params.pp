class io_portalwar::params {
  $ensure                    = 'present'
  $psft_runtime_user_name    = undef
  $oracle_install_group_name = undef
  $index_redirect            = false
  $rename_pia_cookie         = false
  $signon_page               = false
  $config_properties         = false
  $favicons                  = false
  $text_properties           = false
  $redirect_target           = './ps/signon.html'
  $pia_domain_list           = hiera_hash('pia_domain_list')
  $pia_cookie_name           = undef
  $configprop                = undef
  $psserver_list             = undef
  $source                    = undef

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
}
