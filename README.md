# Devon
Vagrant Setup for Network Enthusiast

## Requirement
- Vagrant v.1.9.0
- Virtual Machines (VirtualBox)
- 20 GB Storage

## Specification
### Default OS 
- Lubuntu 16.04

### PORT
- 80 => 8000
- 443 => 44300
- 3306 => 33060
- 4040 => 4040
- 5432 => 54320
- 8025 => 8025
- 27017 => 27017
### Installed Apps 
- PIP
- OpenSSH Server
- GIT
- APT Transport Https
- Software Properties Common

### Available Apps
### Editor
- Nano
- Gedit
- Emacs25
- Pycharm Community
- Visual Studio Code

#### SDN LAB
##### Controller
- POX
- Ryu

##### Simulator
- Mininet with Miniedit

## Installation
First you must clone this repository
    ``` bash
    $ git clone https://github.com/riyadh11/Devon.git
    ```
Then move your default folder to Devon directory
    ``` bash 
    $ cd Devon
    ```
Next Copy Devon.yaml.example to Devon.yaml
    ``` bash
    $ cp Devon.yaml.example Devon.yaml
    ```
After that, configure your devon configuration. Setting that can be customized are cpu core, ram, memory, os, ip and apps
    ``` yaml
    ip: "192.168.10.12"
    memory: 2048
    cpus: 2
    provider: virtualbox
    authorize: ~/.ssh/id_rsa.pub
    keys:
        - ~/.ssh/id_rsa
    folders:
        - map: D:/projects
          to: /home/vagrant/projects
          type: nfs
      
    controllers:
        - ryu
    
    simulator : mininet
    editors :
        - vscode
    browsers :
        - firefox
    ```
    
Fire Up Vagrant
    ``` bash
    $ vagrant up
    ```
Voila.

## Security
If you discover any security related issues, please email ahmad.riyadh.al@faathin.com instead of using the issue tracker.

## Credits
- [https://app.vagrantup.com/halvards](halvards)

## License
The Apache License 2.0 License. Please see [License File](LICENSE.md) for more information.