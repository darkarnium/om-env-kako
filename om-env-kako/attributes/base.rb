# These should never be set in the cookbook, use an attribute override, etc :)
default['om-env-kako']['aws']['access_key_id'] = ''
default['om-env-kako']['aws']['secret_access_key'] = ''

# Define a list of packages to install.
default['om-env-kako']['base']['packages'] = [
  'vim-nox',
  'tmux',
  'git',
]

# Management subnets to permitt SSH traffic from.
default['om-env-kako']['iptables']['management'] = [
  '0.0.0.0/0',
]

# List of ports to permit from all.
default['om-env-kako']['iptables']['permit'] = [
  '2323',
  '5555',
  '7547',
  '8080',
  '8443',
]

# Redirect inbound TCP traffic in order to allow simulations to accept traffic
# on-priviledged ports without elevated system priviledges.
default['om-env-kako']['iptables']['redirect'] = [
  {
    'in' => 23,
    'out' => 2323,
  },
]

# Ensure correct ruby is used
default['om-env-kako']['iptables']['ruby'] = '/opt/chefdk/embedded/bin/ruby'
