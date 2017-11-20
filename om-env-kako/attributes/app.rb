# Set where to install / extract the kako.
default['om-env-kako']['app']['home'] = '/opt/kako'
default['om-env-kako']['app']['user'] = 'kako'

# Set the source git URL.
default['om-env-kako']['app']['git']['use'] = true
default['om-env-kako']['app']['git']['path'] = 'git@github.com:darkarnium/kako.git'
default['om-env-kako']['app']['git']['branch'] = 'master'

# Configuration additions.
default['om-env-kako']['app']['conf'] = {}
