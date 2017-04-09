Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "wiki" do |wiki|

  wiki.vm.box = "bento/centos-7.2"
  wiki.vm.synced_folder ".", "/vagrant"
  wiki.vm.hostname = "wiki.localhost"
  wiki.vm.network :private_network, ip: "172.31.0.202"
  wiki.hostmanager.aliases = %w(wiki)
  wiki.vm.provision "shell", inline: <<-SHELL
    sudo yum update -y
    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    sudo yum install puppet-agent -y
    sudo chkconfig puppet on
  SHELL
 end
  
  config.vm.define "wikidebs" do |wikidebs|

  config.vm.provider "virtualbox" do |vb|
  vb.customize ["modifyvm", :id, "--usb", "on"]
  vb.customize ["modifyvm", :id, "--usbehci", "off"]
end

  wikidebs.vm.box = "ARTACK/debian-jessie"
  wikidebs.vm.synced_folder ".", "/vagrant"
  wikidebs.vm.hostname = "wikidebs.localhost"
  wikidebs.vm.network :private_network, ip: "172.31.0.203"
  wikidebs.hostmanager.aliases = %w(wikidebs)
  wikidebs.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
    sudo dpkg -i puppetlabs-release-pc1-jessie.deb
    sudo apt-get update
    #sudo apt-get upgrade -y
    sudo apt-get install puppet-agent -y
    sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
  SHELL
 end

  config.vm.define "win701" do |win701|
  config.vm.network :forwarded_port, guest: 3389, host: 33389, id: "rdp", auto_correct: true
  
  win701.vm.box = "win7"
  win701.vm.guest = :windows
  win701.vm.communicator = "winrm"
  win701.vm.boot_timeout = 600
  win701.vm.graceful_halt_timeout = 600
  win701.vm.network :private_network, ip: "172.31.0.205"
  win701.hostmanager.aliases = %w(win701)
  win701.vm.hostname = "win701"
  win701.vm.provision "shell", :path => "chocolatey.ps1"


 end

  
  config.vm.define "puppet" do |puppet|

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  puppet.vm.box = "boxcutter/centos72"
  puppet.vm.synced_folder ".", "/vagrant"
  puppet.vm.synced_folder "../code", "/puppet_code"
  puppet.vm.synced_folder "../puppetserver", "/puppet_puppetserver" 
  puppet.vm.hostname = "puppet.localhost"
  puppet.vm.network :private_network, ip: "172.31.0.201"
  puppet.hostmanager.aliases = %w(puppet)
  puppet.vm.provision "shell", inline: <<-SHELL
    sudo yum update -y
    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    sudo yum install puppetserver -y
    sudo rm -rf /etc/puppetlabs/code
    sudo ln -s /puppet_code /etc/puppetlabs/code
    sudo rm -rf /etc/puppetlabs/puppet/hiera.yaml
    sudo ln -s /puppet_code/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
    sudo rm -rf /etc/puppetlabs/puppetserver
    sudo ln -s /puppet_puppetserver /etc/puppetlabs/puppetserver
    sudo sed -i 's/2g/512m/g' /etc/sysconfig/puppetserver
    echo "*.localhost" >> sudo tee /etc/puppetlabs/puppet/autosign.conf
    sudo /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml
    sudo setenforce permissive
    sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux
    sudo cp -r /vagrant/keys /etc/puppetlabs/
    sudo chown puppet:puppet /etc/puppetlabs/keys/private_key.pkcs7.pem
    sudo chown puppet:puppet /etc/puppetlabs/keys/public_key.pkcs7.pem
    sudo chkconfig puppetserver on
    sudo service puppetserver start
  SHELL
 end
end
