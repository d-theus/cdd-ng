#
# Cookbook Name:: dockerails
# Recipe:: www
#

directory File.join('/var', 'www') do
  action :create
  owner 'root'
  group 'deploy'
  mode 0775
end

