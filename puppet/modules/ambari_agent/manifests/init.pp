class ambari_agent ($serverhostname, $repo) {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }


  # Ambari Repo
  exec { 'get-ambari-agent-repo':
    command => "wget ${repo}",
    cwd     => '/etc/yum.repos.d/',
    creates => '/etc/yum.repos.d/ambari.repo',
    user    => root
  }

  exec {'upgrade-openssl': # http://hortonworks.com/community/forums/topic/ambari-agent-registration-failure-on-rhel-6-5-due-to-openssl-2/
    command => "yum upgrade -y openssl",
    user => root,
    require => Exec[get-ambari-agent-repo]
  }

  # Ambari Agent
  package { 'ambari-agent':
    ensure  => present,
    require => Exec[upgrade-openssl]
    #require => Exec[get-ambari-agent-repo]
  }

  file_line { 'ambari-agent-ini-hostname':
    ensure  => present,
    path    => '/etc/ambari-agent/conf/ambari-agent.ini',
    line    => "hostname=${serverhostname}", # server host name
    match   => 'hostname=*',
    require => Package[ambari-agent]
  }

#  exec { 'hostname':
#    command => "hostname ${ownhostname}", # own host name
#    user    => root
#  }

  exec { 'ambari-agent-start':
    command => "ambari-agent start",
    user    => root,
    require => [Package[ambari-agent]],
    onlyif  => 'ambari-agent status | grep "not running"'
  }
}

