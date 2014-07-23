class openfire (
  $ensure             = running,
  $enable             = true,
  $runas_user         = $::openfire::params::runas_user,
  $package            = $::openfire::params::package,
  $package_compat_x86 = $::openfire::params::package_compat_x86,
  $service            = $::openfire::params::service,
  $service_provider   = $::openfire::params::service_provider,
  $logdir             = '/var/log/openfire',
  $mysqluser          = 'openfire',
  $mysqlpassword      = '',
  $mysqldb            = 'openfire',
  $mysqlhost          = 'localhost',
) inherits openfire::params {

  package { [$package, $package_compat_x86]: }

  file { $logdir:
    ensure  => link,
    target  => '/opt/openfire/logs',
    mode    => '0700',
    require => Package[$package],
  }

  file { ['/opt/openfire/logs', '/opt/openfire/plugins', '/opt/openfire/conf']:
    ensure  => directory,
    owner   => $runas_user,
    recurse => true,
    require => Package[$package],
  }

  augeas { 'openfire-basic':
    context => '/files/etc/sysconfig/openfire',
    incl    => '/etc/sysconfig/openfire',
    lens    => 'Shellvars.lns',
    changes => [
      "set OPENFIRE_LOGDIR ${logdir}",
      "set OPENFIRE_USER ${runas_user}",
    ]
  }

  @@mysql::db { $mysqldb:
    user     => $mysqluser,
    password => $mysqlpassword,
    host     => $::fqdn,
    tag      => 'openfire_db',
  }

  service { $service:
    ensure   => $ensure,
    enable   => $enable,
    provider => $service_provider,
    require  => [Package[$package], File[$logdir], Augeas['openfire-basic']],
  }

}
