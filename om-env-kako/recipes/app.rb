#
# Cookbook Name:: om-env-kako
# Recipe:: app
#

# Ensure the app user exists.
user node['om-env-kako']['app']['user'] do
  shell '/usr/sbin/nologin'
  home node['om-env-kako']['app']['home']
  manage_home true
end

# Ensure simulations are up to date.
git node['om-env-kako']['simulations']['home'] do
  repository node['om-env-kako']['simulations']['git']
  revision 'master'
  action :sync
end

# Create AWS directories.
directory ::File.join(node['om-env-kako']['app']['home'], '.aws') do
  owner node['om-env-kako']['app']['user']
  group node['om-env-kako']['app']['user']
  mode '0700'
  recursive true
  action :create
end

# Create AWS credentials in home.
template ::File.join(node['om-env-kako']['app']['home'], '.aws', 'credentials') do
  source 'aws/credentials.erb'
  owner node['om-env-kako']['app']['user']
  mode '0600'
end

# Create AWS configuration in home.
template ::File.join(node['om-env-kako']['app']['home'], '.aws', 'config') do
  source 'aws/config.erb'
  owner node['om-env-kako']['app']['user']
  mode '0600'
end

# Ensure Python 3 is installed.
python_runtime '3'

# Install kako from pypi.
python_package 'kako' do
  install_options '--ignore-installed PyYAML'
end

# Write out the correct configuration document for kako.
deploy_configuration ::File.join(node['om-env-kako']['app']['home'], 'kako.yaml') do
  additions node['om-env-kako']['app']['conf']
end

# Provides a reload facility for systemd - which is only invoked via notify
# on unit file installation, change, etc.
execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

# Install the systemd unit file.
template '/etc/systemd/system/kako.service' do
  mode '0644'
  owner 'root'
  group 'root'
  source 'kako.service.erb'
  variables(
    dir: node['om-env-kako']['app']['home'],
    user: node['om-env-kako']['app']['user'],
    script: [
      '/usr/local/bin/kako-master',
      '--configuration-file',
      ::File.join(node['om-env-kako']['app']['home'], 'kako.yaml'),
      '--simulation-path',
      node['om-env-kako']['simulations']['home']
    ].join(' ')
  )
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'service[kako]', :delayed
end

# Ensure the service runs on boot, and start it.
service 'kako' do
  supports [status: true, restart: true]
  action [:enable, :start]
end

# This is a hack due to fetch any new changes from Git every 30 mins.
# NOTE: This is not the proper way to do things... At all. Ever.
file '/etc/cron.d/update-kako' do
  content [
    '*/30 * * * *',
    'root',
    'cd /var/tmp/chef/ &&',
    'chef-client -z -o "om-env-kako::default" -j /var/tmp/chef/chef.json',
    '> /var/log/chef-client.log 2>&1',
    "\n"
  ].join(' ')
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
