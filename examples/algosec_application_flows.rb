# frozen_string_literal: true

# Managing AlgoSec Application flows

# Define the connection info for your AlgoSec server
algosec = { host: 'local.algosec.com', user: 'admin', password: 'algosec123' }

# Example: Define the application flows for application 'testApp'
# This will delete/modify/create flows as needed to match this flows definition on the server
algosec_application_flows 'define new application flows' do
  algosec_options algosec
  application_name 'testApp'
  application_flows(
    'flow1' => {
      'sources' => ['HR Payroll server', '192.168.0.0/16'],
      'destinations' => ['16.47.71.62'],
      'services' => ['HTTPS'],
    },
    'flow2' => {
      'sources' => ['10.0.0.1'],
      'destinations' => ['10.0.0.2'],
      'services' => ['udp/501'],
    },
    'flow3' => {
      'sources' => ['1.2.3.4'],
      'destinations' => ['3.4.5.6'],
      'services' => ['SSH'],
    }
  )
  action :define
end
