class wordpress::wordpress {
    $wordpress_url = 'http://ja.wordpress.org/wordpress-3.4.1-ja.tar.gz'
    exec {"wget $wordpress_url":
        creates => '/var/tmp/wordpress-3.4.1-ja.tar.gz',
        cwd     => '/var/tmp',
        path    => [ '/usr/bin', '/usr/sbin'],
    }
    
    exec {'tar -zxf /var/tmp/wordpress-3.4.1-ja.tar.gz':
        creates => '/var/www/wordpress',
        cwd     => '/var/www',
        path    => [ '/bin', '/usr/bin'],
        require => Exec["wget $wordpress_url"]
    }
    
    file {'/var/www/wordpress':
        ensure  => directory,
        owner   => apache,
        group   => apache,
        require => [
            Exec['tar -zxf /var/tmp/wordpress-3.4.1-ja.tar.gz'],
            Package['httpd']
        ],
    }

    file { '/etc/httpd/conf.d/wordpress.conf':
        owner => apache,
        group => apache,
        mode => 644,
        source => 'puppet:///modules/wordpress/wordpress.conf',
        require => Package['httpd'],
        notify => Service['httpd'],
    }
}
