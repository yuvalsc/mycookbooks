Chef::Log.info("Creating OS group wasgrp: #{node['WebSphereAS85']['was85-group']} ")
group "#{node['WebSphereAS85']['was85-group']}" do
action :create
end

Chef::Log.info("Creating OS user wasuser and adding to wasgrp")
user "#{node['WebSphereAS85']['was85-user']}" do
  group "#{node['WebSphereAS85']['was85-group']}"
  home "#{node['WebSphereAS85']['was85-home']}"
  action :create
end

Chef::Log.info("Modifying directory permissions to 755")
execute 'recursivedir-permissions' do
  command "chown -R wasuser:wasgrp #{node['WebSphereAS85']['was85-installpath']}"
  action :run
end

Chef::Log.info("Modifying directory permissions to 755")
execute 'recursivedir-permissions' do
  command "find #{node['WebSphereAS85']['was85-installpath']} -type d -exec chmod 755 {} \\;"
  action :run
end

Chef::Log.info("Modifying file permissions to 754")
execute 'recursivefile-permissions' do
  command "find #{node['WebSphereAS85']['was85-installpath']} -type f -exec chmod 754 {} \\;"
  action :run
end
