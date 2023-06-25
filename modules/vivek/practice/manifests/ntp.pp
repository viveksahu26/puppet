class practice::ntp {

  # Manage NTP
    ensure_packages(['ntp'])

    file { '/etc/ntp.conf':
      source  => 'puppet:///modules/vivek/practice/ntp.conf',
      notify  => Service['ntp'],
      require => Package['ntp'],
    }

    service { 'ntp':
      ensure => running,
      enable => true,
    }
}
