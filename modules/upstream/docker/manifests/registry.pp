# @summary
#   Module to configure private docker registries from which to pull Docker images
#
# @param server
#   The hostname and port of the private Docker registry. Ex: dockerreg:5000
#
# @param ensure
#   Whether or not you want to login or logout of a repository
#
# @param username
#   Username for authentication to private Docker registry.
#   auth is not required.
#
# @param password
#   Password for authentication to private Docker registry. Leave undef if
#   auth is not required.
#
# @param pass_hash
#   The hash to be used for receipt. If left as undef, a hash will be generated
#
# @param email
#   Email for registration to private Docker registry. Leave undef if
#   auth is not required.
#
# @param local_user
#   The local user to log in as. Docker will store credentials in this
#   users home directory
#
# @param local_user_home
#   The local user home directory.
#   
# @param receipt
#   Required to be true for idempotency
#
# @param version
#
define docker::registry (
  Optional[String]      $server          = $title,
  Enum[present,absent]  $ensure          = 'present',
  Optional[String]      $username        = undef,
  Optional[String]      $password        = undef,
  Optional[String]      $pass_hash       = undef,
  Optional[String]      $email           = undef,
  String                $local_user      = 'root',
  Optional[String]      $local_user_home = undef,
  Optional[String]      $version         = $docker::version,
  Boolean               $receipt         = true,
) {
  include docker::params

  $docker_command = $docker::params::docker_command

  if $facts['os']['family'] == 'windows' {
    $exec_environment = ["PATH=${facts['docker_program_files_path']}/Docker/",]
    $exec_timeout     = 3000
    $exec_path        = ["${facts['docker_program_files_path']}/Docker/",]
    $exec_provider    = 'powershell'
    $password_env     = '$env:password'
    $exec_user        = undef
  } else {
    $exec_environment = []
    $exec_path        = ['/bin', '/usr/bin',]
    $exec_timeout     = 0
    $exec_provider    = undef
    $password_env     = "\${password}"
    $exec_user        = $local_user
    if $local_user_home {
      $_local_user_home = $local_user_home
    } else {
      # set sensible default
      $_local_user_home = ($local_user == 'root') ? {
        true    => '/root',
        default => "/home/${local_user}",
      }
    }
  }

  if $ensure == 'present' {
    if $username != undef and $password != undef and $email != undef and $version != undef and $version =~ /1[.][1-9]0?/ {
      $auth_cmd         = "${docker_command} login -u '${username}' -p \"${password_env}\" -e '${email}' ${server}"
      $auth_environment = "password=${password}"
    } elsif $username != undef and $password != undef {
      $auth_cmd         = "${docker_command} login -u '${username}' -p \"${password_env}\" ${server}"
      $auth_environment = "password=${password}"
    } else {
      $auth_cmd         = "${docker_command} login ${server}"
      $auth_environment = ''
    }
  }  else {
    $auth_cmd         = "${docker_command} logout ${server}"
    $auth_environment = ''
  }

  $docker_auth = "${title}${auth_environment}${auth_cmd}${local_user}"

  if $auth_environment != '' {
    $exec_env = concat($exec_environment, $auth_environment, "docker_auth=${docker_auth}")
  } else {
    $exec_env = concat($exec_environment, "docker_auth=${docker_auth}")
  }

  if $receipt {
    if $facts['os']['family'] != 'windows' {
      # server may be an URI, which can contain /
      $server_strip = regsubst($server, '/', '_', 'G')

      # no - with pw_hash
      $local_user_strip = regsubst($local_user, '[-_]', '', 'G')

      $_pass_hash = $pass_hash ? {
        Undef   => pw_hash($docker_auth, 'SHA-512', $local_user_strip),
        default => $pass_hash
      }

      $_auth_command = "${auth_cmd} || (rm -f \"/${_local_user_home}/registry-auth-puppet_receipt_${server_strip}_${local_user}\"; exit 1;)"

      file { "/${_local_user_home}/registry-auth-puppet_receipt_${server_strip}_${local_user}":
        ensure  => $ensure,
        content => $_pass_hash,
        owner   => $local_user,
        group   => $local_user,
        notify  => Exec["${title} auth"],
      }
    } else {
      # server may be an URI, which can contain /
      $server_strip  = regsubst($server, '[/:]', '_', 'G')
      $passfile      = "${facts['docker_user_temp_path']}/registry-auth-puppet_receipt_${server_strip}_${local_user}"
      $_auth_command = "if (-not (${auth_cmd})) { Remove-Item -Path ${passfile} -Force -Recurse -EA SilentlyContinue; exit 1 } else { exit 0 }" # lint:ignore:140chars

      if $ensure == 'absent' {
        file { $passfile:
          ensure => $ensure,
          notify => Exec["${title} auth"],
        }
      } elsif $ensure == 'present' {
        exec { 'compute-hash':
          command     => template('docker/windows/compute_hash.ps1.erb'),
          environment => $exec_env,
          provider    => $exec_provider,
          logoutput   => true,
          unless      => template('docker/windows/check_hash.ps1.erb'),
          notify      => Exec["${title} auth"],
        }
      }
    }
  } else {
    $_auth_command = $auth_cmd
  }

  exec { "${title} auth":
    environment => $exec_env,
    command     => $_auth_command,
    user        => $exec_user,
    path        => $exec_path,
    timeout     => $exec_timeout,
    provider    => $exec_provider,
    refreshonly => $receipt,
  }
}
