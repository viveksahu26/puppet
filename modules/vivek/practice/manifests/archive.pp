class practice::archive {
  include archive

  archive { '/tmp/wordpress.tar.gz':
    ensure       => present,
    extract      => true,
    extract_path => '/var/www',
    source       => 'https://wordpress.org/latest.tar.gz',
    creates      => '/var/www/wordpress',
    cleanup      => false,
  }
}
