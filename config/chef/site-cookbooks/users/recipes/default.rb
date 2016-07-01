#
# Cookbook Name:: users
# Recipe:: default
#

data_bag('users').each do |id|
  usr = data_bag_item('users', id, File.read(File.join('/root', '.key')))
  user usr['login'] do
    comment 'Manages docker containers. Handles deployment.'
    manage_home usr['manage_home'] || true
    password usr['password']
  end

  if usr['ssh_authorized_keys']
    directory File.join('/home', usr['login'], '.ssh') do
      owner usr['login']
      group usr['login']
      mode '0700'
    end

    file File.join('/home', usr['login'], '.ssh', 'authorized_keys') do
      content File.read('/root/.ssh/authorized_keys')
      owner usr['login']
      group usr['login']
    end
  end
end

node['groups'].each do |grp, users|
  group grp do
    members users
    append true
  end
end

node['sudoers'].each do |ent, line|
  filename = ent[/\w+/]
  file File.join('/etc', 'sudoers.d', filename) do
    content [ent, line].join('  ')
    action :create
  end
end
