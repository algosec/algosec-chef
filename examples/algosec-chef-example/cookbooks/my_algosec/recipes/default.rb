# frozen_string_literal: true

#
# Cookbook:: my_algosec
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Replace these credentials with those of your AlgoSec(s)
algosec = { host: 'local.algosec.com', user: 'admin', password: 'algosec', ssl_enabled: false }

node['applications'].each do |application|
  algosec_application_flows "define new application #{application['app_name']} flows using a json file" do
    algosec_options algosec
    application_name application['app_name']
    application_flows application['app_flows']
  end
end
