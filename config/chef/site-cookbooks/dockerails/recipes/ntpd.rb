#
# Cookbook Name:: dockerails
# Recipe:: ntpd
#

package 'chrony' do
  action :upgrade
end

execute 'timedatectl set-timezone "Europe/Moscow"'
execute 'timedatectl set-ntp 1'
