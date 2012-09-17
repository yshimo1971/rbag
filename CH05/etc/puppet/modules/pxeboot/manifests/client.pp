define pxeboot::client($mac, $hostname, $password) {
    $filename = template("pxeboot/mac_address.erb")
    file {"pxeboot-${mac}":
        path => "/var/lib/tftpboot/linux-install/$filename",
        ensure => present,
        content => template("pxeboot/default.erb"),
        require => Package["tftp-server"],
    }
    file {"config-${mac}":
        path => "/var/www/html/$filename.ks",
        ensure => present,
        content => template("pxeboot/config.ks.erb"),
        require => Package["tftp-server"],
    }
}
