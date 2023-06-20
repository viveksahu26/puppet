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
 $filepath = '/tmp/hello.txt' 
  file { $filepath:
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

# file with more attributes
  file { '/etc/owned_by_ubuntu':
    ensure => present,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0666',
#    source => 'puppet:///modules/vivek/vivek.txt',
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

# Manage packages
  package { 'ruby':
    ensure => installed,
  }

# Install puppet-lint packages
  package { 'puppet-lint':
    ensure   => installed,
    provider => gem,
  }

  $tasks = ['task1', 'task2', 'task3']
  $tasks.each | $task | {
    file { "/tmp/${task}":
      content => "echo I am ${task}\n",
      mode    => '0766',
    }
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

