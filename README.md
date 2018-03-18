#vansd

This build is to create a docker container running Nginx on a Vagrant virtual machine which is bridged to an external netmork.

There are a few dependancies that need to be provisioned for the build to work.

To be able to build from Vagrant and provision with Ansible, all the details of the new vm
virtual machine need to be populated into an inventory file for the Ansible build :

  machine1      ansible_host=192.168.1.101 ansible_ssh_private_key_file=.vagrant/machines/machine1/virtualbox/private_key



* Pre-Flight Checks

  The network will need to be defined which will depend on the configuration of your host, typically this could a
  local dhcp lan 192.168.1.0 or an internal vlan e.g. 10.10.10.0/24.

    Docker Nginx Container 172.17.0.2:8080  --->   Vagrant Vm -->   192.168.1.101:8080    (public ip )

  If your allocated vlan is 10.10.10.0 then define the network with :

  machine.vm.network "public_network", ip: "10.10.10.#{100+machine_id}"

  Depending on the configuration of the host network interfaces, different bridge network might need to be defined
  in the Vagrantfile, set the interface with no bridged network e.g

  machine.vm.network "public_network", ip: "192.168.1.#{100+machine_id}"

  During the initial Vagrant build, it might ask you which interface to use if there are several available ,

      ==> machine1: Available bridged network interfaces:
          1) enp2s0
          2) docker0
          3) virbr0
          4) br-02db3faa873c
          5) br-17b66dab5ba7
     ==> machine1: When choosing an interface, it is usually the one that is
     ==> machine1: being used to connect to the internet.
         machine1: Which interface should the network bridge to?

  this can then be added into the Vagrantfile with :

  machine.vm.network "public_network", ip: "192.168.1.#{100+machine_id}", bridge: "enp2s0"

  The ip address will need to be added into the Ansible 'inventory' file so it can be used
  to initiate the ssh connection for Ansible.

  Check the Vagrantfile with :

  vagrant validate

  Check the Ansible playbook with :

  ansible-playbook --syntax-check playbook.yml

  The build can be started with :

  vagrant up

  Should the build get interrupted, it can be continued with :

  vagrant provision --provision-with resume

  The Vagrant instance should appear as 'machine1'

  $ vagrant global-status
  id       name     provider   state    directory                           
  --------------------------------------------------------------------------
  890823e  default  virtualbox poweroff /home/pi/devops/vagrant             
  d5685f7  machine1 virtualbox running  /home/pi/devops/vagrant/va   


  The Vagrant vm can be connected by ssh with :

  vagrant ssh

  The Nginx web page running in Docker can be checked with curl :

  $ curl http://192.168.1.101:8080


* Resources

* Vagrant Ansible integration
  https://www.vagrantup.com/docs/provisioning/ansible_local.html

* Ansible Inventory
  http://docs.ansible.com/ansible/latest/intro_inventory.html

* Ansible Playbooks
  http://docs.ansible.com/ansible/latest/playbooks.html

* Nginx on Alpine Linux
  https://wiki.alpinelinux.org/wiki/Nginx
