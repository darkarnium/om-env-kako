Vagrant.configure('2') do |config|
  config.vm.box = 'generic/ubuntu1604'
  config.vm.box_check_update = true

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.memory = '1024'
  end

  # Sync the development directory.
  config.vm.provision 'shell', inline: 'sudo rm -rf /tmp/kako'
  config.vm.provision 'file', source: '../kako', destination: '/tmp/kako'
  config.vm.provision 'shell', inline: 'sudo rsync -av /tmp/kako/ /opt/kako'
  config.vm.provision 'shell', inline: 'sudo chown -R kako: /opt/kako'

  # Bus the provisioning cookbook to the machine.
  config.vm.provision 'file', source: './om-env-kako', destination: '/var/tmp/provisioning'

  # Provision the VM with Chef.
  config.vm.provision 'shell', path: 'deploy-local.sh'
end
