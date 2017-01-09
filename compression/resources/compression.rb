
#
# Cookbook Name:: weblogic
# Resource:: weblogic-server

resource_name :compression
actions :run, :nothing
default_action :run
#property :file_path, String, name_property: true
#property :destination_folder, String, default: lazy { "." }
#property :checksums, String, default: lazy { "." }
#property :folder_name, String, default: 'scp_unzip'
attribute :file_path,      :kind_of => String, :name_attribute => true
attribute :file_name,      :kind_of => String, :default => '*.zip'
attribute :checksum,       :kind_of => String
attribute :download_dir,   :kind_of => String, :default => Chef::Config[:file_cache_path]
attribute :agroup,         :kind_of => String, :default => 'root'
attribute :auser,          :kind_of => String, :default => 'root'
attribute :amode,          :kind_of => String, :default => '00755'
attribute :target_dir,     :kind_of => String, :default => Chef::Config[:file_cache_path]
attribute :creates,        :kind_of => String
attribute :remove_target,  :kind_of => String, :default => 'false'
attribute :compression_exe,:kind_of => String, :default => 'unzip'
attribute :compress_char,  :kind_of => String, :default => '-u -o'
attribute :flags,          :kind_of => String, :default => ''
attribute :scpcommand  ,   :kind_of => String, :default => 'scp user@host:path'
attribute :uncompress,     :kind_of => String, :default => 'true'
attribute :do_scp,         :kind_of => String, :default => 'true'

action :run do
  directory target_dir do
  end

  if do_scp == 'true'
    execute 'scp-file' do
      action :run
      #command "scp #{node['scp_unzip']['ftploginuser']}@#{node['scp_unzip']['binaryhost']}:#{file_path} #{destination_folder}"
      command "#{scpcommand}#{file_path} #{target_dir}"
      cwd "#{target_dir}"
      not_if do ::File.exist?("#{target_dir}/#{file_name}") end
    end
    ruby_block "Validate Package Checksum" do
     action :nothing
     block do
       require 'digest'
       checksum = Digest::SHA256.file("#{target_dir}/#{file_path}").hexdigest
       if checksum != checksums
         raise "#{file_path} Downloaded package Checksum #{checksum} does not match known checksum #{checksums}"
       end
     end
    end
  end

  execute 'extract-file' do
   action :run
     command "#{compression_exe} #{compress_char} #{target_dir}/#{file_name} #{flags}"
     cwd "#{target_dir}"
     #not_if do ::File.exist?("#{destination_folder}/repository.config") end
     only_if uncompress
  end

  file "#{target_dir}/#{file_name}" do
    action :delete
    only_if uncompress
  end

  directory target_dir do
    mode amode
    owner auser
    group agroup
    recursive true
    #action :nothing
  end

  execute "chown-#{target_dir}" do
    command "chown -R #{auser}:#{agroup} #{target_dir}; chmod -R #{amode} #{target_dir}"
    action :run
  end

  Chef::Log.info("echo #{amode} #{auser} #{agroup} #{target_dir}")
  directory target_dir do
    action :delete
    recursive true
    only_if "#{remove_target}"
  end
end

action :nothing do
end
