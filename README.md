# AlgoSec Chef Cookbook

Chef Cookbook to DevOps-ify network security management, leveraging AlgoSec's business-driven security policy management solution.

Maintaining compatibility between applications and their network permission requirements can be a challenging task for many organizations. This Cookbook together with AlgoSec's solution and Chef automation infrastructure will make it as easy as committing a simple `json` file for each application. DevOps made simple...Engineers love it!


## SCOPE

This cookbook is concerned with all [AlgoSec](https://www.algosec.com) services:

- AlgoSec BusinessFlow
- AlgoSec FireFlow
- AlgoSec Firewall Analyzer

## Requirements

- Chef 12.7+
- AlgoSec Ruby SDK >= 0.1.0 (automatically installed upon first execution)

## Usage

This cookbook is not intended to include any recipes.
Use it by specifying a dependency on this cookbook in your own cookbook.

Please see the [Examples README](examples/README.md) for a thorough explanation of how to use this package.
The README file will walk you through all the steps from installing Chef and its dependencies, to running a live example. 

```ruby
# my_cookbook/metadata.rb
depends 'algosec'

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
```

## Testing

For more details look at the [TESTING.md](./TESTING.md).

All static code tests are simply run by:
```
bundle exec rake
```

To actually test the code, please refer to the `examples/README.md` file and apply against a
 TEST app in your AlgoSec Demo VM machine. 

## Custom Resources
Currently, the AlgoSec Chef Cookbook include only one custom resource which is highly useful: The `algosec_application_flows`.

### algosec_application_flows

This custom resource is used to define a set of application flows for a given application on AlgoSec BusinessFlow. 
The resource will delete/modify/create flows as needed to make the list of application flows on the server match the exact request made by the Chef cookbook (defined by you).

#### Common Use Cases

* A team of engineers in your company are developing an application that is frequently deployed within the network. With some of the changes, new requirements for network permissions are presented. 
 Leveraging AlgoSec BusinessFlow and Chef using the `algosec_application_flows`, all they need to do is ship a `flows.json` file along with their code. This file will be loaded onto AlgoSec BusinessFlow by Chef and AlgoSec solution would deploy it to the network.

#### Examples
To see an example of how to use this custom resource you can choose from a few options based on your level of familiarity with AlgoSec Chef Cookbook and Chef in general:
* See the [Usage](#Usage) section in this README file for a short example.
* See the [Examples README.md](examples/README.md) for a full step-by-step guide that will show you how to use this resource.

## License & Authors

If you would like to see the detailed LICENCE click [here](./LICENSE).

- Author:: AlgoSec <dev@algosec.com>