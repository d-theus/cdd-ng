#
# Cookbook:: dockerails
# Recipe:: fluentd
#

package %w(gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel) do
  action :upgrade
end

gem_package 'fluentd' do
  action :upgrade
end

directory '/var/log/fluentd/' do
  action :create
  owner 'root'
  group 'root'
  mode  '0744'
end

directory '/etc/fluent/' do
  action :create
  owner 'root'
  group 'root'
  mode  '0744'
end

file '/etc/fluent/fluent.conf' do
  action :create
  content <<EOF
<source>
  @type  forward
  @id    input1
  @label @mainstream
  port  24224
</source>

<filter **>
  @type stdout
</filter>

<label @mainstream>
  <match **>
    @type file
    @id   output1
    path         /var/log/fluentd/data.*.log
    symlink_path /var/log/fluentd/data.log
    append       true
    time_slice_format %Y%m%d
    time_slice_wait   10m
    time_format       %Y%m%dT%H%M%S%z
  </match>
</label>
EOF
end

file '/etc/systemd/system/fluentd.service' do
  action :create
  content <<EOF
[Unit]
Description=Fluentd service
Requires=network.target
After=network.target
[Service]
Type=simple
ExecStart=/opt/chef/embedded/bin/fluentd
Restart=on-failure
[Install]
WantedBy=network.target
EOF
end
