#
# Cookbook Name:: tpat
# Resource:: tpat managment

resource_name :tpat
default_action :install
property :version, String, name_property: true
property :cache_path, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], "tpat-#{version}") } #tpat_websphere_v3.6_131216_b01
property :home, String, default: lazy { Dir.home(ownername) }
property :extract_path, String, default: lazy { ::File.join(home, "install") }
property :installer_file, String, default: lazy { "#{version}.tar" }
property :installer_file_hash, String, default: 'C3316E609D0F20C630CE476E329A740C126380CEF00328F65B201140869953E8'
property :ownername, String, default: 'was'
property :groupname, String, default: 'oinstall'
property :modename, String, default: '00755'
property :installer_url, String, default: lazy {
"#{node['tpat']['ftppath']}/#{installer_file}"
}
property :scp_url, String, default: lazy {
"scp #{node['tpat']['ftploginuser']}@#{node['tpat']['binaryhost']}:"
}
property :set_env_file, String, default: lazy { 'set_tpat.env' }
property :set_env_path, String, default: lazy { ::File.join(extract_path, set_env_file) }


action :install do
  group groupname do
  end

  user ownername do
    gid groupname
    home "/home/#{ownername}"
    shell '/bin/bash'
  end

  execute "chown-/home/#{ownername}" do
    command "chown -R #{ownername}:#{groupname} /home/#{ownername}; chmod -R 755 /home/#{ownername}"
    action :run
  end

  if !::File.exist?("#{node['tpat']['install_path']}/env/portdef.env")
    directory extract_path do
      mode modename
      owner ownername
      group groupname
      recursive true
    end

    Chef::Log.info("#{installer_url}")
    compression installer_url do
      #action :nothing
      target_dir extract_path
      file_name installer_file
      scpcommand scp_url
      checksum installer_file_hash
      remove_target 'false'
      compression_exe 'tar'
      compress_char 'xf'
      flags '--strip-components 1'
      auser ownername
      agroup groupname
    end

    template set_env_path do
      mode modename
      owner ownername
      group groupname
      source set_env_file + '.erb'
      cookbook 'tpat'
      variables(
        home: "#{node['tpat']['install_path']}",
      )
    end

    template "#{extract_path}/response.txt" do
      mode modename
      owner ownername
      group groupname
      source 'response.txt.erb'
      cookbook 'tpat'
      #notifies :run, 'execute[install_tpat]', :immediately
    end

    bash 'install_tpat' do
      environment 'HOME' => home
      user ownername
      group groupname
      cwd "#{home}/install"
      code <<-EOH
        #{home}/install/setup.ksh < response.txt
        EOH
    end

    directory "#{home}/install" do
      action :delete
      recursive true
    end
  end
end
