Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }

# fix dnsmasq, which looks for /bin/test
file { '/bin/test':
   ensure => 'link',
   target => '/usr/bin/test',
}

#import "classes/*"

node default {

#	class { 'consul_client': 
#		service_name => hiera('svc_name'),
#		health_path  => '/vagrant/demo/health.py',
#	}

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

#        package{"dnsmasq": ensure => installed,}
#
#        file{"/etc/dnsmasq.d/10-consul":
#           ensure =>  'present',
#           content => 'server=/consul/127.0.0.1#8600',
#           notify  => Service['dnsmasq'],
#           require => Package['dnsmasq'],
#        }
#
#        service{'dnsmasq': ensure => running, }


        include dnsmasq
	
       dnsmasq::dnsserver { 'forward-zone-consul':
	     domain => "consul",
	     ip     => "127.0.0.1",
	     port   => "8600",
       }

#	consul::service { $service_name:
#		tags           => ['actuator'],
#		port           => 8080,
#		check_script   => $health_path,
#		check_interval => '5s',
#	}

}

if $::puppetversion >= '3.6.1' {
  Package {
    allow_virtual => true,
  }
}

