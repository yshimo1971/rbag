class wordpress::httpd {
    package {'httpd':
        ensure => latest,
    }
    
    package {'php':
        ensure  => latest,
        require => Package['httpd'],
    }
    
    package {'php-mysql':
        ensure  => latest,
        require => [Package['httpd'], Package['php']],
    }
    
    service {'httpd':
        ensure => running,
        enable => true,
        require => Package['httpd'],
    }
}
