#
# Cookbook Name:: wp
# Attributes:: deafault
#
# Author:: Takayuki Miyauchi
# License: MIT
#

default[:wp][:version]    = 'latest'
default[:wp][:src_dir]    = '/usr/share/wp-cli'
default[:wp][:link]       = '/usr/bin/wp'
default[:wp][:installer]  = 'https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'

default[:wp][:url]  = 'http://127.0.0.1'
default[:wp][:title]  = 'Welcome to the WordPress'

default[:wp][:admin][:user]  = 'admin'
default[:wp][:admin][:pass]  = 'wordpress'
default[:wp][:admin][:email]  = 'admin@example.com'

default[:wp][:config][:locale]             = 'en_US'
default[:wp][:config][:prefix]             = 'wp_'
default[:wp][:config][:debug_mode]         = 0
default[:wp][:config][:force_ssl_admin]    = 0
default[:wp][:config][:savequeries]        = 0
default[:wp][:config][:disallow_file_edit] = 0
default[:wp][:config][:disallow_file_mods] = 0

default[:wp][:db][:user]   = 'wordpress'
default[:wp][:db][:pass]   = 'wordpress'
default[:wp][:db][:name]   = 'wordpress'
default[:wp][:db][:host]   = 'localhost'

default[:wp][:httpd][:user]    = 'apache'
default[:wp][:httpd][:group]   = 'apache'
default[:wp][:httpd][:docroot] = '/var/www'


