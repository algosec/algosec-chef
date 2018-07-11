# frozen_string_literal: true

require_relative './../../spec_helper'

describe 'algosec_test::application_flows_define' do
  let(:resource_name) { 'application_flows' }

  let(:flows_in_cookbook) do
    {
      'flow1' => { 'key': 'value' },
      'flow2' => { 'key': 'value' },
    }
  end

  include_context 'chef context'

  it 'does define test application flows' do
    flows_from_server = {
      'flow1' => { 'key': 'value1' },
      'flow2' => { 'key': 'value2' },
    }

    flows_to_delete = []
    flows_to_create = []
    flows_to_modify = %w(flow1 flow2)

    app_revision_id = double('app-revision-id')
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:login)
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:get_app_revision_id_by_name).with('test').and_return(
      app_revision_id
    )
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:get_application_flows_hash).with(
      app_revision_id
    ).and_return(flows_from_server)
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:plan_application_flows).with(
      flows_from_server,
      flows_in_cookbook
    ).and_return([flows_to_delete, flows_to_create, flows_to_modify])
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:implement_app_flows_plan).once.with(
      'test',
      flows_in_cookbook,
      flows_from_server,
      flows_to_delete,
      flows_to_create,
      flows_to_modify
    )
    expect(real_chef_run).to define_algosec_application_flows('define test application flows')
  end

  it 'does not define test application flows' do
    flows_from_server = flows_in_cookbook
    app_revision_id = double('app-revision-id')
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:login)
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:get_app_revision_id_by_name).with('test').and_return(
      app_revision_id
    )
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:get_application_flows_hash).with(
      app_revision_id
    ).and_return(flows_from_server)
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:plan_application_flows).with(
      flows_from_server,
      flows_in_cookbook
    ).and_return([[], [], []])
    expect_any_instance_of(ALGOSEC_SDK::Client).to receive(:implement_app_flows_plan).never

    expect(real_chef_run).to define_algosec_application_flows('define test application flows')
  end
end
