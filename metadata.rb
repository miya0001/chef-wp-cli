name             'wp'
maintainer       'Takayuki Miyauchi'
maintainer_email 'miyauchi@digitalcube.jp'
license          'Apache 2.0'
description      'Installs/Configures wp-cli'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "wp", "Installs and configures wp-cli"
#recipe "wp::install", "installs and configures WordPress"

supports "centos"
supports "redhat"
supports "ubuntu"

depends 'apt'
depends 'apache2'
depends 'nginx'
depends 'mysql'
depends 'php'
depends 'swap'
