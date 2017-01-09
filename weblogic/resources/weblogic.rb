#
# Cookbook Name:: weblogic
# Resource:: weblogic-server

resource_name :weblogic
default_action :install
property :version, String, name_property: true
property :cache_path, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], "weblogic-#{version}") }
property :silent_file, String, default: lazy {
  if Gem::Version.new(@version) < Gem::Version.new('12.1.2.0.0')
    'silent.xml'
  else
    'silent.rsp'
  end
}
property :silent_path, String, default: lazy { ::File.join(cache_path, silent_file) }

property :silent_cmd, String, default: lazy {
  if Gem::Version.new(version) < Gem::Version.new('12.1.2.0.0')
    '-mode=silent -silent_xml='
  else
    '-silent -responseFile '
  end
}

property :component_paths, String, default: lazy {
  v = Gem::Version.new(version)
  v1211 = Gem::Version.new('12.1.1')
  v1212 = Gem::Version.new('12.1.2')
  case
  when v >= v1211 && v < v1212
    'WebLogic Server/Core Application Server|WebLogic Server/Administration Console|WebLogic Server/Configuration Wizard and Upgrade Framework|WebLogic Server/Web 2.0 HTTP Pub-Sub Server|WebLogic Server/WebLogic JDBC Drivers|WebLogic Server/Third Party JDBC Drivers|WebLogic Server/WebLogic Server Clients|WebLogic Server/Xquery Support|WebLogic Server/Server Examples'
  else
    'WebLogic Server/Core Application Server|WebLogic Server/Administration Console|WebLogic Server/Configuration Wizard and Upgrade Framework|WebLogic Server/Web 2.0 HTTP Pub-Sub Server|WebLogic Server/WebLogic JDBC Drivers|WebLogic Server/Third Party JDBC Drivers|WebLogic Server/WebLogic Server Clients|WebLogic Server/WebLogic Web Server Plugins|WebLogic Server/UDDI and Xquery Support|WebLogic Server/Server Examples'
  end
}
property :installer_file, String, default: lazy {
  v = Gem::Version.new(version)
  v1035 = Gem::Version.new('10.3.5')
  v1036 = Gem::Version.new('10.3.6')
  v1211 = Gem::Version.new('12.1.1')
  v1212 = Gem::Version.new('12.1.2')
  v1213 = Gem::Version.new('12.1.3')
  v1221 = Gem::Version.new('12.2.1')
  v1222 = Gem::Version.new('12.2.2')

  case
  when v >= v1035 && v < v1036
    'wls1035_generic.jar'
  when v >= v1036 && v < v1211
    'wls1036_generic.jar'
  when v >= v1211 && v < v1212
    'wls1211_generic.jar'
  when v >= v1212 && v < v1213
    'wls_121200.jar'
  when v >= v1213 && v < v1221
    'fmw_12.1.3.0.0_wls.jar'
  when v >= v1221 && v < v1222
    'fmw_12.2.1.0.0_wls.jar'
  else
    ''
  end
}

property :installer_file_hash, String, default: 'E6EFE85F3AEC005CE037BD740F512E23C136635C63E20E02589EE0D0C50C065C'
property :ownername, String, default: 'oracle'
property :groupname, String, default: 'dba'
property :home, String, default: lazy { "/opt/oracle/Middleware/weblogic-#{version}" }
property :oracle_home, String, default: lazy { "/opt/oracle" }
property :java_home, String, default: lazy { "#{oracle_home}/jvm" }
property :oracle_jdk_file, String, default: 'jdk-7u79-linux-x64.gz'
property :oracle_jdk_file_hash, String, default: '29D75D0022BFA211867B876DDD31A271B551FA10727401398295E6E666A11D90'
property :oracle_patch_file, String, default: 'p16784672_121200_Generic.zip'
property :oracle_patch_file_hash, String, default: '712EDE0BFA80C70190772DCE419D329DEF2C4E584C6F88C949E8B206A9CF5DEE'
property :inventory_path, String, default: lazy { ::File.join(home, 'oraInventory') }
property :installer_path, String, default: lazy { ::File.join(cache_path, installer_file) }
property :patch_path, String, default: lazy { ::File.join(cache_path, oracle_patch_file) }
property :java_path, String, default: lazy { ::File.join(cache_path, oracle_jdk_file) }
property :installer_url, String, default: lazy {
"#{node['weblogic']['ftppath']}/#{version}/#{installer_file}"
}
property :java_url, String, default: lazy {
"#{node['weblogic']['ftppath']}/#{version}/#{oracle_jdk_file}"
}
property :patch_url, String, default: lazy {
"#{node['weblogic']['ftppath']}/#{version}/#{oracle_patch_file}"
}
property :scp_url, String, default: lazy {
"scp #{node['weblogic']['ftploginuser']}@#{node['weblogic']['binaryhost']}:"
}

action :install do
  #node.default['java']['jdk_version'] = oracle_jdk
  #node.default['java']['install_flavor'] = 'oracle'
  #node.default['java']['oracle']['accept_oracle_download_terms'] = true
  #include_recipe 'java'
  # directory "/home/#{ownername}" do
  #   owner 'root'
  #   group 'root'
  #   mode '0755'
  #   action :create
  # end
  group groupname do
  end

  user ownername do
    gid groupname
    home "/home/#{ownername}"
  end

  node.default['oracle']['inventory']['group'] = groupname
  node.default['oracle']['inventory']['user'] = ownername

  # if Gem::Version.new(version) >= Gem::Version.new('12.1.2.0.0')
  #   #include_recipe 'oracle-inventory'
  #   group node['oracle']['inventory']['group'] do
  #     append true
  #     members ownername
  #   end
  # end

  directory cache_path do
    mode 00775
    owner ownername
    group groupname
    recursive true
  end

  directory home do
    mode 00775
    owner ownername
    group groupname
    recursive true
  end

Chef::Log.info("#{installer_url}")
  # remote_file installer_path do
  #   mode 00644
  #   owner ownername
  #   group groupname
  #   source installer_url
  # end

  compression installer_url do
    #action :nothing
    target_dir cache_path
    file_name installer_file
    scpcommand scp_url
    checksum installer_file_hash
    auser ownername
    agroup groupname
  end

  compression patch_url do
    #action :nothing
    #target_dir patch_home
    file_name oracle_patch_file
    scpcommand scp_url
    checksum oracle_patch_file_hash
    auser ownername
    agroup groupname
  end

  compression java_url do
    target_dir java_home
    file_name oracle_jdk_file
    creates "#{java_home}/bin"
    scpcommand scp_url
    checksum oracle_jdk_file_hash
    compression_exe 'gunzip'
    compress_char '-f'
    auser ownername
    agroup groupname
  end

  compression java_url do
    target_dir java_home
    file_name ::File.basename("#{oracle_jdk_file}", ".gz") #=> jdk-7u79-linux-x64
    creates "#{java_home}/bin"
    scpcommand scp_url
    checksum oracle_jdk_file_hash
    compression_exe 'tar'
    compress_char 'xf'
    auser ownername
    agroup groupname
  end

  template silent_path do
    mode 00644
    owner ownername
    group groupname
    source silent_file + '.erb'
    cookbook 'weblogic'
    variables(
      home: home,
      component_paths: component_paths
    )
  end

  # PATH=JAVA_HOME/bin:$PATH
  # export PATH
  execute "install weblogic server #{version}" do
    environment "JAVA_HOME" => "#{java_home}"
    user ownername
    group groupname
    #command "java -jar #{installer_path}  #{silent_cmd}#{silent_path}"
    command "which java"
    only_if { Dir["#{home}/*"].empty? }
    #action :nothing
  end

  directory cache_path do
    action :delete
    recursive true
  end
end
