Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }



node default {

	class { 'consul': 
		# join_cluster => '172.20.20.10',
		config_hash => {
			'datacenter' => 'dc1',
			'data_dir'   => '/opt/consul',
			'log_level'  => 'INFO',
			'node_name'  => $::hostname,
#			'bind_addr'  => $::ipaddress_eth1,
			'bind_addr'  => '0.0.0.0',
			'bootstrap_expect' => 1,
			'domain'     => 'consul.',
			'recursor'   => '8.8.8.8',
			'server'     => true,
		}
	}

#        package{"dnsmasq": ensure => installed,}

#        file{"/etc/dnsmasq.d/10-consul":
#           ensure =>  'present',
#           content => 'server=/consul/127.0.0.1#8600',
#           notify  => Service['dnsmasq'],
#           require => Package['dnsmasq'],
#        }

#        service{'dnsmasq': ensure => running, }

	include dnsmasq
	
	dnsmasq::dnsserver { 'forward-zone-consul':
		domain => "consul",
		ip     => "127.0.0.1",
		port   => "8600",
	}
}

if $::puppetversion >= '3.6.1' {
  Package {
    allow_virtual => true,
  }
}
