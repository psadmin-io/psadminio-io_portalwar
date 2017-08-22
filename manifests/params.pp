class io_portalwar::params (
  $ensure          = hiera('ensure', 'present'),
  $pia_domain_list = hiera_hash('pia_domain_list'),
  $pia_cookie_name = undef,
  $configprop      = undef,
  $psserver_list   = undef,
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
