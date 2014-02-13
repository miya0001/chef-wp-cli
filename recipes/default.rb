# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

include_recipe "php"

packages = %w{git subversion curl}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

# create wpcli dir
directory node[:wp][:dir] do
  recursive true
end

# download installer
remote_file File.join(node[:wp][:dir], 'wp-cli.phar') do
  source node[:wp][:installer]
  mode 0755
  action :create_if_missing
end

# link wp bin
link node[:wp][:link] do
  to File.join(node[:wp][:dir], 'wp-cli.phar')
end

