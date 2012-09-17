class pxeboot::pxeboot {
        package { 'tftp-server':
                ensure => installed,
                require => [ Package["xinetd"]],
        }

        service { 'tftp':
                enable => true,
                require => Package['tftp-server'],
        }

        package { 'xinetd':
                ensure => installed,
        }

        service { 'xinetd':
                enable => true,
                ensure => running,
        }

        package { 'syslinux':
                ensure => installed,
        }

        file { '/var/lib/tftpboot/linux-install':
                ensure => directory,
                owner => root,
                group => root,
                mode => 655,
                require => Package['tftp-server'],
	}


        file { '/var/lib/tftpboot/linux-install/pxelinux.0':
                source => '/usr/share/syslinux/pxelinux.0',
                owner => root,
                group => root,
                mode => 644,
                require => Package['tftp-server'],
        }

	file { '/var/lib/tftpboot/linux-install/vmlinuz':
		source => '/media/CentOS_6.3_Final/images/pxeboot/vmlinuz',
                owner => root,
                group => root,
                mode => 644,
                require => Package['tftp-server'],
	}

	file { '/var/lib/tftpboot/linux-install/initrd.img':
		source => '/media/CentOS_6.3_Final/images/pxeboot/initrd.img',
                owner => root,
                group => root,
                mode => 644,
                require => Package['tftp-server'],
	}

        $filename = "default"
        file {"/var/lib/tftpboot/linux-install/${filename}":
            content  => template("pxeboot/default.erb"),
            owner => root,
            group => root,
            mode => 644,
            require => Package['tftp-server'],
       }
}
