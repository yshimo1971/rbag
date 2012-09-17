class wordpress::mysqld {
    package {'mysql-server':
        ensure => latest,
    }
    
    package {'mysql':
        ensure => latest,
    }
    
    service {'mysqld':
        enable  => true,
        ensure  => running,
        require => Package['mysql-server'],
    }
    
    exec {'set-mysql-password':
        unless  => "mysqladmin -uroot -p$mysql_password status",
        path    => ['/bin', '/usr/bin'],
        command => "mysqladmin -uroot password $mysql_password",
        require => Service['mysqld'],
    }
}        
