Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
include ntp
include dnsmasq

if $::puppetversion >= '3.6.1' {
  Package {
    allow_virtual => true,
  }
}


host { $::hostname:
	ip => $::ipaddress_eth1,
}

dnsmasq::dnsserver { 'forward-zone-consul':
	domain => "consul",
	ip     => "127.0.0.1",
	port   => "8600",
}

class { 'resolv_conf':
	nameservers => ['127.0.0.1','192.168.20.1'],
}

class { 'consul': 
	# join_cluster => '172.20.20.10',
	config_hash => {
		'datacenter' => 'dc1',
		'data_dir'   => '/opt/consul',
		'log_level'  => 'INFO',
		'node_name'  => $::hostname,
#		'bind_addr'  => $::ipaddress_eth1,
		'bind_addr'  => '0.0.0.0',
		'bootstrap_expect' => 1,
		'domain'     => 'consul.',
		'recursor'   => '8.8.8.8',
		'server'     => true,
	}
}

class { 'ambari_server':
	repo => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo",
}

class { 'ambari_agent':
	repo => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo",
	serverhostname => $::hostname,
}

Class['dnsmasq'] -> Class['ntp'] -> Class['resolv_conf'] -> Class['consul'] -> Class['ambari_server'] -> Class['ambari_agent']

