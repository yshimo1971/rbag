class pxeboot::httpd {
    package {'httpd':
          ensure => installed,
    }

    service {'httpd':
        enable => true,
        ensure => running,
        require => Package['httpd'],
    }

    file { '/etc/httpd/conf.d/pxeboot.conf':
        owner => apache,
        group => apache,
        mode => 644,
        source => 'puppet:///modules/pxeboot/pxeboot.conf',
        require => Package['httpd'],
        notify => Service['httpd'],
    }

    replace {"/etc/httpd/conf/httpd.conf":
        file => "/etc/httpd/conf/httpd.conf",
        pattern=> "#ServerName www.example.com:80", 
        replacement => "ServerName $ipaddress",
        require => Package['httpd'],
        notify => Service['httpd'],
    }

    define replace($file, $pattern, $replacement) {
        exec {"/bin/sed -i -e 's/$pattern/$replacement/g' $file":
            unless => "/bin/grep $pattern $file"
        }
    }
}
