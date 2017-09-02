# io_portalwar::signon
#
# Deploy custom signon pages to each PIA site
#
# @summary This class will take the list of pages defined in Hiera
#   and deploy them to each PIA site.
#
# @example
#   include io_portalwar::signon_page
class io_portalwar::signon_page (
  $pia_domain_list = $io_portalwar::pia_domain_list
){


}
