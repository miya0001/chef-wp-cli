#
# Cookbook Name:: wp
# Attributes:: deafault
#
# Author:: Takayuki Miyauchi
# License: MIT
#

default[:wp][:dir]        = '/usr/share/wp-cli'
default[:wp][:link]       = '/usr/bin/wp'
default[:wp][:installer]  = 'https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
