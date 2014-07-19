class openfire::dbhost (
  $mysqlpassword,
  $serverhostname = 'localhost',
  $mysqluser      = 'openfire',
  $mysqldb        = 'openfire',
) {

  if downcase($serverhostname) in downcase([ $::fqdn, $::hostname ]) {
    $openfireserver = 'localhost'
  }
  else {
    $openfireserver = $serverhostname
  }

  mysql::db { $mysqldb:
    user     => $mysqluser,
    password => $mysqlpassword,
    host     => $openfireserver
  }
}
