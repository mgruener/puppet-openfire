class openfire::params {
  # technically openfire runs on windows and mac too, but for the
  # moment only linux support is implemented in this module
  if $::kernel != 'Linux' {
    fail("${module_name} is only supported on Linux")
  }

  # no debian support at the moment...
  case $::operatingsystem {
    /^Fedora|^RedHat|^CentOS/: {
        $package = 'openfire'
        $package_compat_x86 = 'glibc.i686'
        $service = 'openfire'
        $service_provider = 'redhat'
        $runas_user = 'daemon'
      }
    default: { fail("${module_name} is not supported on ${::operatingsystem}") }
  }
}
