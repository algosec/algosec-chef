# frozen_string_literal: true

require_relative './../../lib_spec_helper'

RSpec.describe 'AlgoSecHelper' do
  include_context 'shared context'

  let(:helper) do
    (Class.new { include AlgoSecCookbook::Helper }).new
  end

  let(:sdk_version) do
    '>= 0.1'
  end

  describe '#load_sdk' do
    before :each do
      allow(helper).to receive(:node).and_return('algosec' => { 'ruby_sdk_version' => sdk_version })
    end

    it 'loads the specified version of the gem' do
      expect(helper).to receive(:gem).with('algosec-sdk', sdk_version)
      helper.load_sdk
    end

    it 'attempts to install the gem if it is not found' do
      expect(helper).to receive(:gem).and_raise LoadError
      expect(helper).to receive(:chef_gem).with('algosec-sdk').and_return true
      expect(helper).to receive(:require).with('algosec-sdk').and_return true
      helper.load_sdk
    end
  end

  describe '#build_client' do
    it 'requires a parameter' do
      expect { helper.build_client }.to raise_error(/wrong number of arguments/)
    end

    it 'requires a valid algosec object' do
      expect { helper.build_client(nil) }.to raise_error(/Invalid client/)
    end

    it 'accepts a hash' do
      algosec = helper.build_client(@algosec_options)
      expect(algosec.host).to eq(@algosec_options[:host])
      expect(algosec.user).to eq(@algosec_options[:user])
      expect(algosec.password).to eq(@algosec_options[:password])
    end

    it 'defaults the log level to what Chef is using' do
      algosec = helper.build_client(@algosec_options)
      expect(algosec.log_level).to eq(Chef::Log.level)
    end

    it 'allows the log level to be overridden' do
      level = Chef::Log.level == :warn ? :info : :warn
      algosec = helper.build_client(@algosec_options.merge(log_level: level))
      expect(algosec.log_level).to eq(level)
      expect(algosec.log_level).to_not eq(Chef::Log.level)
    end
  end
end
