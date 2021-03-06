default['WebSphereAS85']['name'] = 'WebSphere'
default['WebSphereAS85']['message'] = 'Installing WebSphere Application Server version 8.5.5 to /opt/IBM/WebSphere'
default['WebSphereAS85']['package-name-1'] = 'WAS_ND_V8.5.5_1_OF_3.zip'
default['WebSphereAS85']['package-name-2'] = 'WAS_ND_V8.5.5_2_OF_3.zip'
default['WebSphereAS85']['package-name-3'] = 'WAS_ND_V8.5.5_3_OF_3.zip'
default['WebSphereAS85']['package-fix9-1'] = '8.5.5-WS-WAS-FP0000009-part1.zip'
default['WebSphereAS85']['package-fix9-2'] = '8.5.5-WS-WAS-FP0000009-part2.zip'
default['WebSphereAS85']['package-java'] = '7.1.3.30-WS-IBMWASJAVA-Linux.zip'
default['WebSphereAS85']['package-im'] = 'agent.installer.linux.gtk.x86_64_1.8.4000.20151125_0201.zip'
#default['WebSphereAS85']['webserver'] = 'http://9.191.4.209'
default['WebSphereAS85']['binaryhost'] = '192.168.175.134'
default['WebSphereAS85']['ftploginuser'] = 'ftplogin'
default['WebSphereAS85']['ftppath'] = '/WAS'
default['WebSphereAS85']['ftpfolderspath'] = ['ND', 'FIX', 'JAVA', 'IM']
default['WebSphereAS85']['was_version'] = '1.8.3000.20150606_0047'
default['WebSphereAS85']['was_install_dir'] = '/opt/IBM/WebSphere'
default['WebSphereAS85']['imshared_install_dir'] = 'opt/IBM/IMShared'
default['WebSphereAS85']['imagentdata_install_dir'] = '/opt/IBM/IMAgentData'
default['WebSphereAS85']['imcl_install_dir'] = '/opt/IBM/InstallationManger'
default['WebSphereAS85']['imcl-path'] = "#{node['WebSphereAS85']['imcl_install_dir']}/eclipse/tools"
default['WebSphereAS85']['java_install_dir'] = '/opt/IBM/jvm'
default['WebSphereAS85']['was-responsefile'] = 'WAS85Install.xml'
default['WebSphereAS85']['was-id'] = 'IBM WebSphere Application Server'
default['WebSphereAS85']['package1-sha256sum'] = 'b1333962ba4b25c8632c7e4c82b472350337e99febac8f70ffbd551ca3905e83'
default['WebSphereAS85']['package2-sha256sum'] = '440b7ed82089d43b1d45c1e908bf0a1951fed98f2542b6d37c8b5e7274c6b1c9'
default['WebSphereAS85']['package3-sha256sum'] = 'b73ae070656bed6399a113c2db9fb0abaf5505b0d41c564bf2a58ce0b1e0dcd2'
default['WebSphereAS85']['fix9-1-sha256sum'] = 'bf0817f50472c7f1ad0c50863ff0e7a07fb73f69f09a60bfad798d2b3cc1e3ae'
default['WebSphereAS85']['fix9-2-sha256sum'] = 'c5501a75da3ab78887fa0208f26d7d81517e39a0c7e184bf36d28fbc93acbe22'
default['WebSphereAS85']['java-sha256sum'] = '3d498013284b6a15f7090f786ca292286b2ed6a8e7250f7451790194b4c778a2'
default['WebSphereAS85']['im-sha256sum'] = '28f5279abc28695c0b99ae0c3fdee26bfec131186f2ca7e41d1317e303adb12e'
default['WebSphereAS85']['java-packageid'] = 'com.ibm.websphere.IBMJAVA.v71_7.1.3030.20160224_1952'
default['WebSphereAS85']['fix-packageid'] = 'com.ibm.websphere.ND.v85_8.5.5009.20160225_0435'
default['WebSphereAS85']['was85-packageid'] = 'com.ibm.websphere.ND.v85'
default['WebSphereAS85']['was85-profiledesc'] = 'IBM WebSphere Application Server V8.5'
default['WebSphereAS85']['was85-features'] = 'core.feature,com.ibm.sdk.6_64bit'
default['WebSphereAS85']['was85-installpath'] = "#{node['WebSphereAS85']['was_install_dir']}/AppServer"
default['WebSphereAS85']['was85-binpath'] = "#{node['WebSphereAS85']['was85-installpath']}/bin"
default['WebSphereAS85']['was85-dmgrname'] = 'Dmgr01'
default['WebSphereAS85']['was85-appsrvname'] = 'ManagedAppServers'
default['WebSphereAS85']['was85-user'] = 'was'
default['WebSphereAS85']['was85-group'] = 'oinstall'
default['WebSphereAS85']['wasuserhome'] = "/home/#{node['WebSphereAS85']['was85-user']}"
