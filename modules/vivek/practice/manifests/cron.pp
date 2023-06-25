
class practice::cron {
  
  cron { 'cron date example':
    command     => '/bin/date +%F',
    user        => 'ubuntu',
    environment => ['MAILTO=viveksahu26@example.com', 'PATH=/bin'],
    hour        => '0',
    minute      => '0',
    weekday     => ['Saturday', 'Sunday'],
  }
}

