class practice::docker {

  # include the docker class
  include ::docker

  # fetch the docker image
  ::docker::image { 'nginx':
    ensure    => 'present',
    image_tag => 'stable-alpine',
    require   => Class['docker'],
  }

  # run the container using the image above
  ::docker::run { 'nginx':
    image   => 'nginx:stable-alpine',
    ports   => ['8080:80'],
    require => Docker::Image['nginx'],
  }

}
