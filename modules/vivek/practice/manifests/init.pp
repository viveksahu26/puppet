# Default nginx server
class practice  {
#  include ::practice::ntp
  include ::practice::cron
  include ::practice::exec
  include ::practice::docker
  include ::practice::iteration
  include ::practice::apache
  include ::practice::archive
  notice($facts['kernel'])


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
  file { '/tmp/owned_by_ubuntu2':
    ensure => present,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0666',
#    source => 'puppet:///modules/vivek/vivek.txt',
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

  lookup('users2', Hash, 'hash').each | String $username, Hash $attrs | {
  user { $username:
    * => $attrs,
   }
  }

}

