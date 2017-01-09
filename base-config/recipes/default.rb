#
# Cookbook Name:: base-config
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
execute "update-upgrade" do
  command "echo 'Yuval Schwabe' `date` >> /tmp/test.txt"
  action :run
end
