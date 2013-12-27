Vagrant::Config.run do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'schnitzelpress-dev'

  config.vm.forward_port 9292, 9292

  config.vm.provision :puppet do |puppet|
    puppet.module_path = './modules'
    puppet.manifests_path = '.'
    puppet.manifest_file = 'dev.pp'
  end
end