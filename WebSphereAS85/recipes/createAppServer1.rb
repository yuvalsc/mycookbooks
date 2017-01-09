Chef::Log.info("AppServer Path is #{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']} ")

execute 'createAppSrv' do
  path = "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']}"
  path = path.strip
  not_if do FileTest.directory?(path) end
  command "#{node['WebSphereAS85']['was85-binpath']}/manageprofiles.sh -create -profileName #{node['WebSphereAS85']['was85-appsrvname']} -profilePath #{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']} -templatePath #{node['WebSphereAS85']['was85-installpath']}/profileTemplates/managed -nodeName #{node["hostname"]}Node -cellName tempCell -hostname #{node["hostname"]}"
  cwd "#{node['WebSphereAS85']['was85-binpath']}"
  action :run
end


template "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']}/properties/soap.client.props" do
  source 'soap-client-props.erb'
  owner 'root'
  group 'root'
  mode '0644'
end


execute 'addNode' do
  path = "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']}"
  path = path.strip
  not_if do FileTest.directory?(path) end
  command "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']}/bin/addNode.sh #{node["hostname"]} 8879"
  cwd "#{node['WebSphereAS85']['was85-installpath']}/profiles/#{node['WebSphereAS85']['was85-appsrvname']}/bin"
  action :run
end