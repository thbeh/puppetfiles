class spring_boot_app (
	$service_name = 'unknown',
	$jar_path     = 'unknown',
	$health_path  = 'unknown',
) {

	#
	# Spring Boot Application
	#

	package {["openjdk-7-jdk"]:
		ensure => present,
	}

	file { '/opt/health.py':
		path         => '/opt/health.py',
		ensure       => present,
		mode         => 0755,
		source       => $health_path,
	}

	file { '/opt/demo.jar':
		notify       => Service[$service_name],
		path         => '/opt/demo.jar',
		ensure       => present,
		source       => $jar_path,
	}

	file { '/etc/init/demo.conf':
		path         => "/etc/init/${service_name}.conf",
		ensure       => present,
		source       => '/vagrant/demo/demo-init.conf',
	}

	service { $service_name:
	    ensure  => "running",
	    enable  => "true",
		require => [
			Package["openjdk-7-jdk"],
			File["/opt/health.py"],
			File["/etc/init/demo.conf"],
			File["/opt/demo.jar"],
		]
	}


}