#FTP/SCP connection properties
default['tpat']['binaryhost'] = '192.168.175.134'
default['tpat']['ftppath'] = '/TPAT'
default['tpat']['ftploginuser'] = 'ftplogin'
default['tpat']['ftppassword'] = 'ftplogin'

#TPAT template properties
default['tpat']['home'] = '/home/was'
default['tpat']['install_path'] = "#{node['tpat']['home']}/dh"
default['tpat']['ftploginuser'] = 'ftplogin'
