#
# Cookbook Name:: dockerails
# Recipe:: docker
#

file '/etc/yum.repos.d/docker.repo' do
  action :create
  content <<EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
end

package 'docker-engine' do
  action :upgrade
end

group 'docker' do
  action :create
  members %w(admin web)
end

service 'docker' do
  provider Chef::Provider::Service::Systemd
  action [:enable, :start]
end

package 'python-pip' do
  action :upgrade
end

execute 'pip install docker-compose'
