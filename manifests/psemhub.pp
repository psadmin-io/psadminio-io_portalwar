# io_portalwar::psemhub
#
# Remove the PSEMHUB (Environment Management Hub) web module from the
# deployed PeopleSoft EAR. Mitigation for CVE-2026-35273 (Oracle Security
# Alert, June 2026) per Oracle's documented fix for single server domains:
#
#   1. Remove the PSEMHUB <module> entry from META-INF/application.xml
#   2. Remove the exploded PSEMHUB.war folder
#
# Notes:
#   - Linux only. Single server PIA domains only. For multi-server domains
#     with a dedicated PSEMHUB managed server, stop/disable that server
#     instead.
#   - A PIA bounce is required for a running domain to pick this up
#     (stop -> puppet apply -> start). During full DPK provisioning,
#     ensure this runs before domain boot.
#   - Re-running after a PIA redeploy/tools patch re-removes the hub,
#     which is the point: this makes the mitigation DPK-durable.
#
# @example psft_customizations.yaml settings
#   ---
#   # Enable this class (io_portalwar/init.pp contains it when true)
#   io_portalwar::remove_psemhub: true
#
# @example Run this manifest directly with puppet apply (as root)
#   # DPK_HOME is your DPK base, e.g. /opt/oracle/psft/dpk
#   $PS_CFG_HOME/webserv/<domain>/bin/stopPIA.sh
#
#   puppet apply --confdir $DPK_HOME/puppet \
#     -e "class { '::io_portalwar': remove_psemhub => true }"
#
#   $PS_CFG_HOME/webserv/<domain>/bin/startPIA.sh
#
#   # If io_portalwar::remove_psemhub: true is already set in psft_customizations.yaml,
#   # the -e payload can simply be: 'include ::io_portalwar'
#   # Note: declare the parent class (not the subclass alone) so
#   # pia_domain_list and friends resolve from hiera.
class io_portalwar::psemhub (
  $ensure          = 'absent',
  $pia_domain_list = $io_portalwar::pia_domain_list,
) {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $ear_dir         = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft"
    $app_xml         = "${ear_dir}/META-INF/application.xml"

    augeas { "${domain_name} remove PSEMHUB from application.xml" :
      lens    => 'Xml.lns',
      incl    => $app_xml,
      context => "/files${app_xml}/application",
      changes => "rm module[web/web-uri/#text='PSEMHUB.war']",
      onlyif  => "match module[web/web-uri/#text='PSEMHUB.war'] size > 0",
    }

    file { "${ear_dir}/PSEMHUB.war" :
      ensure  => $ensure,
      force   => true,
      backup  => false,
      require => Augeas["${domain_name} remove PSEMHUB from application.xml"],
    }

  } # end pia_domain_list

}
