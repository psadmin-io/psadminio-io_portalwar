class io_portalwar::params (
  $ensure                    = hiera('ensure', 'present'),
  $psft_runtime_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $domain_user               = hiera('domain_user', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list'),
  $index_redirect            = false,
  $redirect_target           = './ps/signon.html',
  $pia_cookie_name           = undef,
  $psserver_list             = undef,
  $source                    = undef,
  $signon_page               = undef,
  $text_properties           = undef,
  $config_properties         = undef,
){

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

}
