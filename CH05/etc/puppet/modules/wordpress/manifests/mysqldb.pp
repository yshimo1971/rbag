define wordpress::mysqldb($db_user, $db_password) {
    exec {"create-${name}-db":
        unless  => "/usr/bin/mysql -u${db_user} -p${db_password} ${name}",
        command => "/usr/bin/mysql -uroot -p${mysql_password} -e \"create database ${name}; grant all on ${db_user}.* to ${db_user}@localhost identified by '${db_password}';\"",
        require => Service['mysqld'],
    }
    $url = 'https://api.wordpress.org/secret-key/1.1/salt/'
    $db_name = $name
    file { '/var/www/wordpress/wp-config.php':
        owner => apache,
        group => apache,
        mode => 644,
        content => template('wordpress/wp-config.php.erb'),
        require => File['/var/www/wordpress'],
    }
}
