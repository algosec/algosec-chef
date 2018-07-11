# frozen_string_literal: true

# Cookbook Name:: algosec_test
# Recipe:: application_flows_define
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

algosec_application_flows 'define test application flows' do
  algosec_options node['algosec_test']['algosec']
  application_name 'test'
  application_flows(
    'flow1' => { 'key': 'value' },
    'flow2' => { 'key': 'value' }
  )
  action :define
end
