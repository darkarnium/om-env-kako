#
# Cookbook Name:: om-env-kako
# Recipe:: base
#

# Ensure apt is refreshed before start - per force attribute(s).
include_recipe 'apt'

# Apply all sysctl values from attributes.
include_recipe 'sysctl::apply'

# Ensure NTP is configured.
include_recipe 'ntp::default'

# Ensure iptables is configured for use with Chef LWRPs.
include_recipe 'iptables'

# Install ulimit configuration.
template '/etc/security/limits.d/base.conf' do
  source 'ulimit-nofile.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Install base system packages.
node['om-env-kako']['base']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

# Comine all required iptables rule files.
iptables_rule 'iptables-prefix' do
  action :enable
end

iptables_rule 'iptables-base' do
  action :enable
end

iptables_rule 'iptables-permit' do
  action :enable
end

iptables_rule 'iptables-redirect' do
  action :enable
end

# Ensure rebuild-iptables uses the right ruby...
begin
  r = resources(template: '/usr/sbin/rebuild-iptables')
  r.cookbook 'iptables'
  r.variables(hashbang: node['om-env-kako']['iptables']['ruby'])
end
