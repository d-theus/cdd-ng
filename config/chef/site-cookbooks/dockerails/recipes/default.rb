#
# Cookbook Name:: dockerails
# Recipe:: default
#

execute "yum -y update"
package 'epel-release' do
  action :upgrade
end
package 'git' do
  action :upgrade
end
package 'postfix' do
  action :remove
end
