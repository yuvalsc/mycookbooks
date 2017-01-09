
Chef::Log.info("This VM has IP address #{node["ipaddress"]} and hostname: #{node["hostname"]};  WAS binary bath is #{node['WebSphereAS85']['was85-installpath']}/bin")
Chef::Log.info("Dmgr Path is #{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']} ")

group "#{node['WebSphereAS85']['was85-group']}" do
end

user "#{node['WebSphereAS85']['was85-user']}" do
  gid "#{node['WebSphereAS85']['was85-group']}"
  home "#{node['WebSphereAS85']['wasuserhome']}"
end

if !::File.directory?("#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}")
  template "/tmp/WAS-dmgr-responsefile.rsp" do
    source 'WAS-dmgr-responsefile.rsp.erb'
    owner "#{node['WebSphereAS85']['was85-user']}"
    group "#{node['WebSphereAS85']['was85-group']}"
    mode '0644'
    variables(
      profileTemplatePath: "#{node['WebSphereAS85']['was85-installpath']}",
      profilePath: "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}",
      nodeName: "#{node['WebSphereAS85']['was85-dmgrname']}Node",
      cellName: "#{node['WebSphereAS85']['was85-dmgrname']}Cell",
      hostname: "#{node['hostname']}",
      profileName: "Dmgr01"
    )
      notifies :run, 'execute[createDmgr]', :immediately
  end

  execute 'createDmgr' do
    path = "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}"
    path = path.strip
    not_if do FileTest.directory?(path) end
    environment 'LANG' => "en_US.UTF-8", 'LANGUAGE' => "en_US.UTF-8", 'LC_ALL' => "en_US.UTF-8"
    command "#{node['WebSphereAS85']['was85-binpath']}/manageprofiles.sh -response /tmp/WAS-dmgr-responsefile.rsp"
    cwd "#{node['WebSphereAS85']['was85-binpath']}"
    action :nothing
  end

  template "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}/properties/soap.client.props" do
    source 'soap-client-props.erb'
    owner "#{node['WebSphereAS85']['was85-user']}"
    group "#{node['WebSphereAS85']['was85-group']}"
    mode '0644'
  end

  execute 'hosts' do
    path = "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}"
    path = path.strip
    command "echo '127.0.0.1       #{node["hostname"]}  localhost' >> /etc/hosts  "
    cwd "/etc"
    not_if do FileTest.directory?(path) end
    action :run
  end

  execute "chown-#{node['WebSphereAS85']['was_install_dir']}" do
    command "chown -R #{node['WebSphereAS85']['was85-user']}:#{node['WebSphereAS85']['was85-group']} #{node['WebSphereAS85']['was_install_dir']}; chmod -R 755 #{node['WebSphereAS85']['was_install_dir']}"
    action :run
  end

  execute 'startDmgr' do
    path = "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}/logs/dmgr/dmgr.pid"
    path = path.strip
    not_if do FileTest.file?(path) end
    environment 'LANG' => "en_US.UTF-8", 'LANGUAGE' => "en_US.UTF-8", 'LC_ALL' => "en_US.UTF-8"
    command "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}/bin/startManager.sh"
    cwd "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-dmgrname']}/bin"
    action :run
  end
end
