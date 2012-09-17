class pxeboot::dhcpd {
        package { 'dhcp':
                ensure => installed,
        }

        service { 'dhcpd':
                enable => true,
                ensure => running,
                require => [ Package["dhcp"]],
        }

	$gateway = "192.168.36.2"
        $domain_name = "kasai.local"
        $name_server = "192.168.36.2"
        file { '/etc/dhcp/dhcpd.conf':
                #source => 'puppet:///modules/pxeboot/dhcpd.conf',
                content => template('pxeboot/dhcpd.conf.erb'),
                owner => root,
                group => root,
                mode => 644,
                replace => true,
                require => Package['dhcp'],
        }
}
