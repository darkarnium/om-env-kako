# Set the user to run kako as.
default['om-env-kako']['app']['user'] = 'kako'
default['om-env-kako']['app']['home'] = '/home/kako'

# Set the simulation source.
default['om-env-kako']['simulations']['git'] = 'https://github.com/darkarnium/kako-simulations'
default['om-env-kako']['simulations']['home'] = ::File.join(
  node['om-env-kako']['app']['home'],
  'simulations'
)

# Configuration additions.
default['om-env-kako']['app']['conf'] = {
  'logging' => {
    'path' => node['om-env-kako']['app']['home']
  },
  'simulations' => {
    'path' => node['om-env-kako']['simulations']['home']
  },
  'results' => {
    'processor' => 'sns',
    'attributes' => {
      'topic' => 'arn:aws:sns:<region>:<account>:<topic>',
      'region' => 'us-west-2'
    }
  },
  'monitoring' => {
    'enabled' => true,
    'interval' => 60
  }
}
