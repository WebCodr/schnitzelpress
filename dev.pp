$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
exec { 'apt-get -y update':
  unless => "test -e ${home}/.rvm"
}
}
class { 'apt_get_update':
  stage => preinstall
}

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libyaml-dev', 'libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# MongoDB

package { 'mongodb':
  ensure => present,
}

service { 'mongodb':
  ensure  => running,
  require => Package['mongodb'],
}

package { 'libpq-dev':
  ensure => present,
}

class { 'postgresql::server': }

postgresql::server::db { 'schnitzelpress_dev':
  user     => 'schnitzel_dev',
  password => postgresql_password('schnitzel_dev', 'schnitzel'),
}

postgresql::server::db { 'schnitzelpress_test':
  user     => 'schnitzel_test',
  password => postgresql_password('schnitzel_test', 'schnitzel'),
}

# --- Ruby ---------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.0.0 --autolibs=enabled'",
  creates => "${home}/.rvm/bin/ruby",
  timeout => 600,
  require => [ Package['libyaml-dev'], Exec['install_rvm'] ]
}

exec { 'set_default_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm --fuzzy alias create default 2.0.0 && ${home}/.rvm/bin/rvm use default'",
  require => Exec['install_ruby']
}

exec { 'install_bundler':
  command => "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'",
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['set_default_ruby']
}

exec { 'allow remote mongo connections':
  command => "/usr/bin/sudo sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf",
  notify  => Service['mongodb'],
  onlyif  => '/bin/grep -qx  "bind_ip = 127.0.0.1" /etc/mongodb.conf',
}