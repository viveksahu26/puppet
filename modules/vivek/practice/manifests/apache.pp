class practice::apache {
  
  include ::apache

  ::apache::vhost { 'cat-pictures.com':
    port          => 80,
    docroot       => '/var/www/cat-pictures',
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }

  file { '/var/www/cat-pictures/index.html':
    content => "Hi Vivek, puppet here !!",
    owner   => 'www-data',
    group   => 'www-data',
  }
}
