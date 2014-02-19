# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'shellwords'

include_recipe "php::module_mysql"
include_recipe "mysql::client"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:wp][:db][:pass] = secure_password

if node[:wp][:db][:host] == "localhost"
  include_recipe "mysql::server"
end

if node['platform_family'] == 'rhel'
  chef_gem "mysql" do
      action :nothing
      subscribes :install, "package[mysql-devel]", :immediately
  end
else
  chef_gem "mysql" do
      action :nothing
      subscribes :install, "package[libmysqlclient-dev]", :immediately
  end
end

directory node[:wp][:httpd][:docroot] do
  mode   0755
  action :create
end

if node[:wp][:version] == 'latest'
  execute "wordpress-core-download" do
    creates "/var/www/readme.html"
    command "wp core download --allow-root --path=#{Shellwords.shellescape(node[:wp][:httpd][:docroot])} --locale=#{Shellwords.shellescape(node[:wp][:config][:locale])}"
    action :run
  end
elsif node[:wp][:version] =~ %r{^http(s)?://.*?\.zip$}
  execute "wordpress-core-download" do
    creates "/var/www/readme.html"
    command "cd /tmp && wget -O ./download.zip #{Shellwords.shellescape(node['wp-install']['wp_version'])} && unzip ./download.zip && rsync -avz /tmp/wordpress/ #{Shellwords.shellescape(node[:wp][:httpd][:docroot])}/ && rm ./download.zip && rm -fr /tmp/wordpress"
    action :run
  end
else
  execute "wordpress-core-download" do
    creates "/var/www/readme.html"
    command "wp core download --allow-root --path=#{Shellwords.shellescape(node[:wp][:httpd][:docroot])} --locale=#{Shellwords.shellescape(node[:wp][:config][:locale])} --version=#{Shellwords.shellescape(node[:wp][:version])}"
    action :run
  end
end

execute "mysql-install-wp-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node[:mysql][:server_root_password]}\" < #{node[:wp][:src_dir]}/wp-grants.sql"
  action :nothing
end

template File.join(node[:wp][:src_dir], '/wp-grants.sql') do
  source "grants.sql.erb"
  mode "0600"
  variables(
    :user     => node[:wp][:db][:user],
    :password => node[:wp][:db][:pass],
    :database => node[:wp][:db][:name],
    :host     => node[:wp][:db][:host]
  )
  notifies :run, "execute[mysql-install-wp-privileges]", :immediately
end

file File.join(node[:wp][:httpd][:docroot], "wp-config.php") do
  action :delete
  backup false
end

execute "wp-core-config" do
  cwd node[:wp][:httpd][:docroot]
  command <<-EOH
    wp core config --allow-root \\
    --dbhost=#{Shellwords.shellescape(node[:wp][:db][:host])} \\
    --dbname=#{Shellwords.shellescape(node[:wp][:db][:name])} \\
    --dbuser=#{Shellwords.shellescape(node[:wp][:db][:user])} \\
    --dbpass=#{Shellwords.shellescape(node[:wp][:db][:pass])} \\
    --dbprefix=#{Shellwords.shellescape(node[:wp][:config][:prefix])} \\
    --locale=#{Shellwords.shellescape(node[:wp][:config][:locale])} \\
    --extra-php <<PHP
define( 'WP_DEBUG',           #{node[:wp][:config][:debug_mode]} );
define( 'FORCE_SSL_ADMIN',    #{node[:wp][:config][:force_ssl_admin]} );
define( 'DISALLOW_FILE_EDIT', #{node[:wp][:config][:disallow_file_edit]} );
define( 'DISALLOW_FILE_MODS', #{node[:wp][:config][:disallow_file_mods]} );
PHP
EOH
  action :run
end

execute "wp-db-create" do
  cwd node[:wp][:httpd][:docroot]
  command "wp db create --allow-root"
  action :run
end

execute "wordpress-core-install" do
  cwd node[:wp][:httpd][:docroot]
  command <<-EOH
    wp core install --allow-root \\
    --url=#{Shellwords.shellescape(node[:wp][:url]).sub(/\/$/, '')} \\
    --title=#{Shellwords.shellescape(node[:wp][:title])} \\
    --admin_user=#{Shellwords.shellescape(node[:wp][:admin][:user])} \\
    --admin_password=#{Shellwords.shellescape(node[:wp][:admin][:pass])} \\
    --admin_email=#{Shellwords.shellescape(node[:wp][:admin][:email])}
  EOH
  action :run
end

