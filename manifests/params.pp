class io_portalwar::params {
  $ensure                    = 'present'
  $psft_runtime_user_name    = 'psadm1'
  $oracle_install_group_name = 'oinstall'
  $index_redirect            = false
  $rename_pia_cookie         = false
  $signon_page               = false
  $config_properties         = false
  $favicons                  = false
  $text_properties           = false
  $redirect_target           = './ps/signon.html'
  $pia_domain_list           = undef
  $pia_cookie_name           = undef
  $configprop                = undef
  $psserver_list             = undef
  $jolt_port                 = undef

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
