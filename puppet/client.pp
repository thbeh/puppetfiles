Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
include ntp
include dnsmasq

if $::puppetversion >= '3.6.1' {
  Package {
    allow_virtual => true,
  }
}

# fix dnsmasq, which looks for /bin/test
file { '/bin/test':
   ensure => 'link',
   target => '/usr/bin/test',
}

dnsmasq::dnsserver { 'forward-zone-consul':
     domain => "consul",
     ip     => "127.0.0.1",
     port   => "8600",
}

class { 'resolv_conf':
	nameservers => ['127.0.0.1','192.168.20.1'],
}
	
#class { 'consul_client': 
#	service_name => hiera('svc_name'),
#	health_path  => '/vagrant/demo/health.py',
#}

class { 'consul':
	# join_cluster => hiera('join_addr'),
	config_hash => {
		'datacenter' => 'dc1',
		'data_dir'   => '/opt/consul',
		'log_level'  => 'INFO',
		'node_name'  => $::hostname,
#		'bind_addr'  => $::ipaddress_eth1,
		'server'     => false,
		'recursor'   => '8.8.8.8',
		'start_join' => [hiera('join_addr')],
	}
}

#consul::service { $service_name:
#	tags           => ['actuator'],
#	port           => 8080,
#	check_script   => $health_path,
#	check_interval => '5s',
#}

class { 'ambari_agent':
        repo => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo",
        serverhostname => [hiera('server_ip')],
}

Class['dnsmasq'] -> Class['ntp'] -> Class['resolv_conf'] -> Class['consul'] -> Class['ambari_agent']

