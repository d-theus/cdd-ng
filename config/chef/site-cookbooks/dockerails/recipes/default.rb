#
# Cookbook Name:: dockerails
# Recipe:: default
#

execute "yum -y update"
package 'epel-release' do
  action :upgrade
end
