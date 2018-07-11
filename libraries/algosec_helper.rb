# frozen_string_literal: true

module AlgoSecCookbook
  ## Helper module to load the algosec-ruby-sdk gem and build the client object
  module Helper
    # Load (and install if necessary) the algosec-sdk
    def load_sdk
      gem 'algosec-sdk', node['algosec']['ruby_sdk_version']
      require 'algosec-sdk'
      Chef::Log.debug("Found gem algosec-sdk (version #{node['algosec']['ruby_sdk_version']})")
    rescue LoadError
      Chef::Log.info("Did not find gem algosec-sdk (version #{node['algosec']['ruby_sdk_version']}). Installing now")
      chef_gem 'algosec-sdk' do
        version node['algosec']['ruby_sdk_version']
        compile_time true if Chef::Resource::ChefGem.method_defined?(:compile_time)
      end
      require 'algosec-sdk'
    end

    # Makes it easy to build a ALGOSEC_SDK::Client object
    # @param [Hash, ALGOSEC_SDK::Client] algosec Machine info or client object.
    # @return [ALGOSEC_SDK::Client] Client object
    def build_client(algosec)
      case algosec
      when Hash
        log_level = algosec['log_level'] || algosec[:log_level] || Chef::Log.level
        ALGOSEC_SDK::Client.new(algosec.merge(log_level: log_level))
      else
        raise "Invalid client #{algosec}. Must be a hash or ALGOSEC_SDK::Client"
      end
    end
  end
end
