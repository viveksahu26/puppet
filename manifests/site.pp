
file {'/tmp/it_works.txt':
  ensure => present,
  mode => '0644',
  content => "Finally puppet agent success in creating this file.\n",
}

include vivek
