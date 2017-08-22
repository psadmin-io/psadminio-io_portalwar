class io_portalwar::params (
  $pia_domain_list = undef,
  $pia_cookie_name = undef,
  $configprop      = undef,
  $psserver_list   = undef,
){

  case $::facts['os']['name'] {
    'AIX':     {
    }
    'Solaris': {
    }
    'windows': {
    }
    default:   {
    }
  }

  validate_hash($pia_domain_list)

}
