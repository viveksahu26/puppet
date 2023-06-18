# Default nginx server
class vivek  {
  package { 'apache2':
  ensure => installed,
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
    require => Package['apache2'],
  }

# create a file 
  file { '/tmp/hello.txt':
    ensure  => file,
    content => "Hi goodbye, world and all\n",
  }

# Install package cowsay
  package { 'cowsay':
    ensure => installed,
  }

# Install package cowsay
  package { 'atop':
    ensure => installed,
  }

# manage files with permission
  file { '/tmp/hello':
    ensure => present,
#    owner  => 'ubuntu',
#    mode   => '0755',
#    group  => 'ubuntu',
    source => 'puppet:///modules/vivek/vivek.txt',
  }

# file with more attributes
  file { '/etc/owned_by_ubuntu':
    ensure => present,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0666',
  }

# file --> directories
  file {'/etc/config_dir':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0666',
  }

# file --> symlink
  file {'/etc/this_is_a_link':
    ensure => link,
    target => '/etc/owned_by_ubuntu',
  }
# Install 
#  package { 'mysql-server':
#    ensure => installed,
#    notify => Service['mysql'],
#  }
#
#  file { '/etc/mysql/mysql.conf':
#    source  => '/examples/files/mysql.conf',
#    notify  => Service['mysql'],
#    require => Package['mysql-server'],
#  }
#
#  service { 'mysql':
#    ensure  => running,
#    enable  => true,
#    require => [Package['mysql-server'], File['/etc/mysql/mysql.cnf']],
#  }
  
 # include docker
#  docker::image { 'ubuntu':
 #   ensure       => 'latest',
 # }
}

