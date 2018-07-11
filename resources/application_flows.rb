# frozen_string_literal: true

require_relative '../libraries/algosec_helper'

resource_name :algosec_application_flows

property :algosec_options, Hash, required: true
property :application_name, String, name_property: true
property :application_flows, Hash, required: true
# property :application_flows, Hash, required: true, callbacks: {
#   'should be an hash of stringy flow name to hash' => -> {},
#   'each flow contain sources, destinations and services which are array of strings' => -> {},
#   'non required fields (users, applications) are array of strings if they were defined' => -> {},
#   'commend field is a string if it was defined' => -> {},
# }

action_class do
  # Include the helpers
  include AlgoSecCookbook::Helper
end

action :define do
  load_sdk
  client = build_client(new_resource.algosec_options)
  client.login
  flows_from_server = client.get_application_flows_hash(
    client.get_app_revision_id_by_name(new_resource.application_name)
  )
  flows_to_delete, flows_to_create, flows_to_modify = client.plan_application_flows(
    flows_from_server,
    new_resource.application_flows
  )
  change_needed = [flows_to_delete.any?, flows_to_create.any?, flows_to_modify.any?].any?
  if change_needed
    converge_by "Re-defining application flows."\
                " Creating #{flows_to_create.length},"\
                " modifying #{flows_to_modify.length}"\
                " and deleting #{flows_to_delete.length}" do
      client.implement_app_flows_plan(
        new_resource.application_name,
        new_resource.application_flows,
        flows_from_server,
        flows_to_delete,
        flows_to_create,
        flows_to_modify
      )
    end
  end
end
