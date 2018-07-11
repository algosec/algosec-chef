# frozen_string_literal: true

require 'algosec-sdk'
require 'chef/log'
require_relative '../libraries/algosec_helper'
require 'pry'

# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    ALGOSEC_SDK::ENV_VARS.each { |e| ENV[e] = nil } # Clear environment variables

    @algosec_options = { host: 'https://algosec.example.com', user: 'admin', password: 'algosec123' }
    @client = ALGOSEC_SDK::Client.new(@algosec_options)
  end
end
