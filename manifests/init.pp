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
  $signon_page               = undef,
  $text_properties           = undef,
  $config_properties         = undef,
  $favicons                  = undef,
){

  notify{'Applying module io_portalwar':}

  case $::osfamily {
    'AIX':     {
      $platform = 'AIX'
      $extract_command = 'unzip -o -j %s -d '
      $fileowner       = $psft_install_user_name
    }
    'Solaris': {
      $platform = 'SOLARIS'
      $extract_command = 'unzip -o -j %s -d '
      $fileowner       = $psft_install_user_name
    }
    'windows': {
      $platform = 'WIN'
      $extract_command = '7z e -y -o'
      $fileowner       = $domain_user
    }
    default:   {
      $platform = 'LINUX'
      $extract_command = 'unzip -o -j %s -d '
      $fileowner       = $psft_install_user_name
    }
  }

  validate_hash($pia_domain_list)

  if ($io_portalwar::index_redirect) {
    contain ::io_portalwar::index_redirect
  }

  if ($io_portalwar::pia_cookie_name) {
    contain ::io_portalwar::cookie_name
  }

  if ($io_portalwar::signon_page) {
    contain ::io_portalwar::signon_page
  }

  if ($io_portalwar::config_properties) {
    contain ::io_portalwar::config_properties
  }
  
  if ($io_portalwar::text_properties) {
    contain ::io_portalwar::text_properties
  }

  if ($io_portalwar::favicons) {
    contain ::io_portalwar::favicons
  }
}
