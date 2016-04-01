#
# Cookbook Name:: joomla
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "git" do
action :install
end

bash 'extract_module' do
  code <<-EOH
  mkdir /tmp/new
  rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm

    EOH
  not_if { ::File.exists?('/tmp/new') }
end

package ['php56w','php56w-mysql','php56w-common','php56w-pdo','php56w-pdo'] do
  action :install
  notifies :restart, 'service[httpd]', :immediately
end
git '/var/www/html' do
   repository 'https://github.com/UnnatiKulkarni/joomla-app.git'
   revision 'master'
   action :sync
end

package 'unzip' do
	action:install
end

bash 'copy_joomla' do
  code <<-EOH
		
	sudo chown -R apache:apache /var/www/html
	cd /var/www/html
	unzip Joomla_3.5.0-Stable-Full_Package.zip 
  EOH
end

cookbook_file '/var/www/html/info.php' do
  source 'info.php'
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
  notifies :restart, 'service[httpd]', :immediately
end
