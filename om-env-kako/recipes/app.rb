#
# Cookbook Name:: om-env-kako
# Recipe:: app
#

# Ensure the app user exists.
user node['om-env-kako']['app']['user'] do
  shell '/bin/false'
  home node['om-env-kako']['app']['home']
  manage_home false
end

# Fetch and install the kako from the given branch - if required.
if node['om-env-kako']['app']['git']['use']
  git node['om-env-kako']['app']['home'] do
    action :sync
    notifies :run, 'execute[chown-kako]', :immediately
    reference node['om-env-kako']['app']['git']['branch']
    repository node['om-env-kako']['app']['git']['path']
    environment(
      GIT_SSH_COMMAND: [
        'ssh',
        ' -o UserKnownHostsFile=/dev/null',
        ' -o StrictHostKeyChecking=no',
      ].join('')
    )
  end

  execute 'chown-kako' do
    action :nothing
    notifies :restart, 'service[kako]', :delayed
    command [
      'chown -R',
      node['om-env-kako']['app']['user'],
      node['om-env-kako']['app']['home'],
    ].join(' ')
  end
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
  group node['om-env-kako']['app']['user']
  mode '0600'
end

# Create AWS configuration in home.
template ::File.join(node['om-env-kako']['app']['home'], '.aws', 'config') do
  source 'aws/config.erb'
  owner node['om-env-kako']['app']['user']
  group node['om-env-kako']['app']['user']
  mode '0600'
end

# Ensure Python 2 is installed.
python_runtime '2'

# Install required Python modules.
pip_requirements "#{node['om-env-kako']['app']['home']}/requirements.txt"

# Write out the correct configuration document for kako.
deploy_configuration "#{node['om-env-kako']['app']['home']}/conf/kako.dist.yaml" do
  destination "#{node['om-env-kako']['app']['home']}/conf/kako.yaml"
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
  mode 0644
  owner 'root'
  group 'root'
  source 'kako.service.erb'
  variables(
    dir: node['om-env-kako']['app']['home'],
    user: node['om-env-kako']['app']['user'],
    script: "#{node['om-env-kako']['app']['home']}/runner.py"
  )
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

# Ensure the service runs on boot, and start it.
service 'kako' do
  supports status: true, restart: true
  action [:enable, :start]
end

# This is a hack due to fetch any new changes from Git every 30 mins.
# NOTE: This is not the proper way to do things... At all. Ever.
file '/etc/cron.d/update-kako' do
  content [
    '*/30 * * * *',
    'root',
    'chef-client -z -o "om-env-kako::default" -j /var/tmp/chef/chef.json',
    "\n",
  ].join(' ')
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
