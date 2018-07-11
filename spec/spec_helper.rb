# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'
require 'pry'
require 'algosec-sdk'

at_exit { ChefSpec::Coverage.report! }

log_level = :fatal
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '16.04',
  log_level: log_level,
  file_cache_path: '/tmp',
}.freeze

WINDOWS_OPTS = {
  platform: 'windows',
  version: '2012R2',
  log_level: log_level,
  file_cache_path: 'c:\chef',
}.freeze

RSpec.configure do |config|
  # Set the default platform and version
  config.platform = 'redhat'
  config.version = '7.2'
end

# General context for unit testing:
RSpec.shared_context 'chef context', a: :b do
  before :each do
    ALGOSEC_SDK::ENV_VARS.each { |e| ENV[e] = nil } # Clear environment variables
    @algosec_options = { host: 'https://ilo.example.com', user: 'Administrator', password: 'secret123' }
    @client = ALGOSEC_SDK::Client.new(@algosec_options)
  end

  let(:real_chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ["algosec_#{resource_name}"]
    )
    runner.converge(described_recipe)
  end
end
