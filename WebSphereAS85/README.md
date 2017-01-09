WebSphereAS85 Cookbook
======================

This cookbook installs WebSphere Application Server Network Deployment version 8.5.5 and configures a cell.
Creates Deployment Manager, creates Application Server Node and federates the node to create a cell.
This cookbook assumes that Installation Manager is  installed at /opt/IBM/InstallationManager path. You can use my InstallationManager cookbook to achieve this with chef. I did not make this a dependency for various reasons, but I have tested that including as a dependency works just fine.
This cookbook can be used with my FTPlogin cookbook to scp binaries required to copy. I am not including the binaries in this cookbook.

The code also verifies the checksum of the files after copying to the node. The install will fail if the checksum fails.

Requirements
------------
Platforms: Ubuntu 14.04, 15.04

Attributes
----------
default['WebSphereAS85']['name'] = 'WebSphereAS85'

default['WebSphereAS85']['message'] = 'Installing WebSphere Application Server version 8.5.5 to /opt/IBM/WebSphere'

default['WebSphereAS85']['package-name-1'] = 'WASND_v8.5.5_1of3.zip'

default['WebSphereAS85']['package-name-2'] = 'WASND_v8.5.5_2of3.zip'

default['WebSphereAS85']['package-name-3'] = 'WASND_v8.5.5_3of3.zip'

default['WebSphereAS85']['binaryhost'] = 'IP address of the host where binaries are located.'

default['WebSphereAS85']['ftploginuser'] = 'User to login with'

default['WebSphereAS85']['ftppath'] = 'Path where the binaries are stored'

default['WebSphereAS85']['was_version'] = '1.8.3000.20150606_0047'

default['WebSphereAS85']['was_install_dir'] = '/opt/IBM/WebSphere'

default['WebSphereAS85']['imshared_install_dir'] = 'opt/IBM/IMShared'

default['WebSphereAS85']['imagentdata_install_dir'] = '/opt/IBM/IMAgentData'

default['WebSphereAS85']['imcl_install_dir'] = '/opt/IBM/InstallationManger'

default['WebSphereAS85']['was-responsefile'] = 'WAS85Install.xml'

default['WebSphereAS85']['was-id'] = 'IBM WebSphere Application Server'

default['WebSphereAS85']['package1-sha256sum'] = 'b1333962ba4b25c8632c7e4c82b472350337e99febac8f70ffbd551ca3905e83'

default['WebSphereAS85']['package2-sha256sum'] = '440b7ed82089d43b1d45c1e908bf0a1951fed98f2542b6d37c8b5e7274c6b1c9'

default['WebSphereAS85']['package3-sha256sum'] = 'b73ae070656bed6399a113c2db9fb0abaf5505b0d41c564bf2a58ce0b1e0dcd2'

default['WebSphereAS85']['imcl-path'] = '/opt/IBM/InstallationManager/eclipse/tools/imcl'

default['WebSphereAS85']['was85-packageid'] = 'com.ibm.websphere.ND.v85'

default['WebSphereAS85']['was85-profiledesc'] = 'IBM WebSphere Application Server V8.5'

default['WebSphereAS85']['was85-features'] = 'core.feature,com.ibm.sdk.6_64bit'

default['WebSphereAS85']['was85-installpath'] = '/opt/IBM/WebSphere/AppServer'

default['WebSphereAS85']['was85-binpath'] = '/opt/IBM/WebSphere/AppServer/bin'

default['WebSphereAS85']['was85-dmgrname'] = 'Dmgr01'

default['WebSphereAS85']['was85-appsrvname'] = 'ManagedAppServers'

default['WebSphereAS85']['was85-user'] = 'wasuser'

default['WebSphereAS85']['was85-group'] = 'wasgrp'

default['WebSphereAS85']['wasuserhome'] = '/home/wasuser'


Usage
-----
Add to the node's run list

knife node run_list add <node name> 'recipe[WebSphereAS85::default]'

knife node run_list add <node name> 'recipe[WebSphereAS85::createDmgr]'

knife node run_list add <node name> 'recipe[WebSphereAS85::createAppServer]'

knife node run_list add <node name> 'recipe[WebSphereAS85::healthcheck]'

License and Authors
-------------------
Rohit Gabriel, Auckland, New Zealand.

Profile: https://nz.linkedin.com/in/rohit-gabriel-22a76320
