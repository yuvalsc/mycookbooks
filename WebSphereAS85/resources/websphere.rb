#
# Cookbook Name:: WebSphere
# Resource:: WebSphere-server

resource_name :WebSphere
default_action :install
property :version, String, name_property: true

action :install do
  wasbinary_dir = "#{Chef::Config[:file_cache_path]}/WASbinaries"
  nd_binaries = [ "#{node['WebSphereAS85']['package-name-1']}", "#{node['WebSphereAS85']['package-name-2']}", "#{node['WebSphereAS85']['package-name-3']}"]
  nd_checksums = [ "#{node['WebSphereAS85']['package1-sha256sum']}", "#{node['WebSphereAS85']['package2-sha256sum']}", "#{node['WebSphereAS85']['package3-sha256sum']}"]
  fix_binaries = [ "#{node['WebSphereAS85']['package-fix9-1']}", "#{node['WebSphereAS85']['package-fix9-2']}"]
  fix_checksums = [ "#{node['WebSphereAS85']['fix9-1-sha256sum']}", "#{node['WebSphereAS85']['fix9-2-sha256sum']}"]
  im_binaries = [ "#{node['WebSphereAS85']['package-im']}"]
  im_checksums = [ "#{node['WebSphereAS85']['im-sha256sum']}"]
  java_binaries = [ "#{node['WebSphereAS85']['package-java']}"]
  java_checksums = [ "#{node['WebSphereAS85']['java-sha256sum']}"]
  binaries_folders = node['WebSphereAS85']['ftpfolderspath']

  was_dir = "#{node['WebSphereAS85']['was_install_dir']}"
  im_dir = "#{node['WebSphereAS85']['imcl_install_dir']}"
  imagentdata_dir = "#{node['WebSphereAS85']['imagentdata_install_dir']}"
  imshared_dir = "#{node['WebSphereAS85']['imshared_install_dir']}"
  wasuserhome = "#{node['WebSphereAS85']['wasuserhome']}"

  if !::File.exist?("#{node['WebSphereAS85']['was85-binpath']}/manageprofiles.sh")
    directory wasuserhome do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end

    directory wasbinary_dir do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end

    directory 'was_dir' do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end

    binaries_folders.each { | folder_name |
      directory "#{wasbinary_dir}/#{folder_name}" do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end
    }

    def copy_files (folder_name, file_name, destination_folder, checksums)
      execute 'copy-WAS' do
        action :run
        command "scp #{node['WebSphereAS85']['ftploginuser']}@#{node['WebSphereAS85']['binaryhost']}:#{node['WebSphereAS85']['ftppath']}/#{folder_name}/#{file_name} #{destination_folder}"
        cwd "#{destination_folder}"
        not_if do ::File.exist?("#{destination_folder}/#{file_name}") end
      end
      ruby_block "Validate Package Checksum" do
       action :nothing
       block do
         require 'digest'
         checksum = Digest::SHA256.file("#{destination_folder}/#{file_name}").hexdigest
         if checksum != checksums
           raise "#{file_name} Downloaded package Checksum #{checksum} does not match known checksum #{checksums}"
         end
       end
      end
      execute 'extract-WAS' do
       action :run
         command "unzip -u -o #{file_name}"
         cwd "#{destination_folder}"
         #not_if do ::File.exist?("#{destination_folder}/repository.config") end
      end
    end

    binaries_folders.each { | folder_name |
      count = 0
      case "#{folder_name}"
      when "ND"
        nd_binaries.each { | package_name |
          copy_files("#{folder_name}", package_name, "#{wasbinary_dir}/#{folder_name}", nd_checksums[count])
          Chef::Log.info("ND #{package_name}")
          count += 1
        }
      when "FIX"
        fix_binaries.each { | package_name |
          copy_files("#{folder_name}", package_name, "#{wasbinary_dir}/#{folder_name}", fix_checksums[count])
          Chef::Log.info("FIX #{package_name}")
          count += 1
        }
      when "IM"
        im_binaries.each { | package_name |
          copy_files("#{folder_name}", package_name, "#{wasbinary_dir}/#{folder_name}", im_checksums[count])
          Chef::Log.info("IM #{package_name}")
          count += 1
        }
      when "JAVA"
        java_binaries.each { | package_name |
          copy_files("#{folder_name}", package_name, "#{wasbinary_dir}/#{folder_name}", java_checksums[count])
          Chef::Log.info("JAVA #{package_name}")
          count += 1
        }
      end
    }


    #fail "Yuval Schwabe"
    template "#{wasbinary_dir}/#{node['WebSphereAS85']['was-responsefile']}" do
      source 'WAS-responsefile.erb'
      variables(
      wasid: "#{node['WebSphereAS85']['was85-packageid']}",
      wasdesc: "#{node['WebSphereAS85']['was85-profiledesc']}",
      wasfeatures: "#{node['WebSphereAS85']['was85-features']}",
      waspath: "#{node['WebSphereAS85']['was85-installpath']}",
      imsharedpath: "#{node['WebSphereAS85']['imshared_install_dir']}",
      wasbinarypath: "#{wasbinary_dir}/ND"
      )
      owner 'root'
      group 'root'
      mode '0644'
      #notifies :run, 'execute[install-WAS85]', :delayed
    end

    execute 'install-IM' do
      #./installc -installationDirectory nondefaultinstalldir -dL nondefaultAgentDataDir -acceptLicense -sVP
      command "#{wasbinary_dir}/IM/installc -installationDirectory #{node['WebSphereAS85']['imcl_install_dir']} -dL '#{node['WebSphereAS85']['imagentdata_install_dir']}' -acceptLicense -sVP"
      cwd "#{wasbinary_dir}/IM"
      action :run
      not_if do ::File.exist?("#{node['WebSphereAS85']['imcl-path']}/imcl") end
    end

    execute 'install-WAS85' do
      command "#{node['WebSphereAS85']['imcl-path']}/imcl -acceptLicense -showProgress input '#{wasbinary_dir}/#{node['WebSphereAS85']['was-responsefile']}' -dataLocation '#{node['WebSphereAS85']['imagentdata_install_dir']}' -log '#{wasbinary_dir}/WAS85NDinstall.log'"
      cwd "#{wasbinary_dir}/ND"
      action :run
      not_if do ::File.exist?("#{node['WebSphereAS85']['was85-binpath']}/manageprofiles.sh") end
    end
    #./imcl uninstall com.ibm.websphere.ND.v85,optional_feature_ID -installationDirectory installation_directory

    execute 'install-FIX' do
      command "#{node['WebSphereAS85']['imcl-path']}/imcl -acceptLicense -showProgress install '#{node['WebSphereAS85']['fix-packageid']}' -repositories '#{wasbinary_dir}/FIX' -installationDirectory '#{node['WebSphereAS85']['was85-installpath']}' -log '#{wasbinary_dir}/WAS85FIXinstall.log'"
      cwd "#{wasbinary_dir}/FIX"
      action :run
      not_if "`grep -q '8.5.5.9' #{node['WebSphereAS85']['was85-installpath']}/properties/version/WAS.product; if [ $? -eq 0 ]; then echo true; else echo false; fi`"
    end

    execute 'install-JAVA' do
      command "#{node['WebSphereAS85']['imcl-path']}/imcl -acceptLicense -showProgress install '#{node['WebSphereAS85']['java-packageid']}' -repositories '#{wasbinary_dir}/JAVA' -installationDirectory '#{node['WebSphereAS85']['was85-installpath']}' -log '#{wasbinary_dir}/WAS85JAVAinstall.log'"
      cwd "#{wasbinary_dir}/JAVA"
      action :run
      not_if do ::File.exist?("#{node['WebSphereAS85']['was85-installpath']}/properties/version/IBM_Java_SE_Runtime_Environment_64bit.1.7.1.cmptag") end
    end

    execute 'Show-Version' do
      command "#{node['WebSphereAS85']['was85-binpath']}/versionInfo.sh"
      cwd "#{node['WebSphereAS85']['was85-binpath']}"
      action :run
      only_if do ::File.exist?("#{node['WebSphereAS85']['was85-binpath']}/versionInfo.sh") end
    end

    directory wasbinary_dir do
      action :delete
      recursive true
    end
  end
end
