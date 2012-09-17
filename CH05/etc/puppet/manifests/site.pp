import 'pxeboot'
import 'wordpress'

node 'centos-102.kasai.local' {
	include pxeboot::pxeboot
        include pxeboot::dhcpd
        include pxeboot::httpd

        pxeboot::client { "node1":
            mac => "00:22:33:33:22:33",
            hostname => "node1",
            password => "3genja82",
	}
}

node 'centos-103.kasai.local' {
    $mysql_password = "root"
    include wordpress::httpd
    include wordpress::mysqld
    include wordpress::wordpress
 
    wordpress::mysqldb { 'wp':
        db_user     => 'wp',
        db_password => 'wp',
    }
}
