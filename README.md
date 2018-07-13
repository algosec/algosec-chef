# AlgoSec Chef Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/algosec.svg?style=flat-square)](https://supermarket.chef.io/cookbooks/algosec)
[![Coverage Status](https://coveralls.io/repos/github/algosec/algosec-chef/badge.svg)](https://coveralls.io/github/algosec/algosec-chef)
[![Build Status](https://travis-ci.org/algosec/algosec-chef.svg)](https://travis-ci.org/algosec/algosec-chef)

Chef Cookbook to DevOps-ify network security management, leveraging AlgoSec's business-driven security policy management solution.

Maintaining compatibility between applications and their network connectivity requirements can be a challenging task for many organizations. This Cookbook together with AlgoSec's solution and Chef automation infrastructure will make it as easy as committing a simple `json` file for each application. DevOps made simple...Engineers love it!


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
Use it by specifying a dependency on this cookbook in your own cookbook and using the custom resources that are defined in this cookbook.

## Custom Resources
Currently, the AlgoSec Chef Cookbook include only one custom resource which is highly useful: The `algosec_application_flows`.

### algosec_application_flows

This custom resource is used to define a set of application flows for a given application on AlgoSec BusinessFlow. 
The resource will delete/modify/create flows as needed to make the list of application flows on the server match the exact request made by the Chef cookbook (defined by you).

The application flows and application flows for this resource can be defined in an external `flows.json` file which be loaded with the Chef Zero run.

#### Common Use Case

* A team of engineers in your company are developing an application that is frequently deployed within the network. With some of the changes, new requirements for network connectivity are presented. 
 Leveraging AlgoSec BusinessFlow and Chef using the `algosec_application_flows`, all they need to do is ship a `flows.json` file along with their code. This file will be loaded onto AlgoSec BusinessFlow by Chef and AlgoSec solution would deploy it to the network.

#### Usage Examples

To see an example of how to use this custom resource you can choose from a few options based on your level of familiarity with AlgoSec Chef Cookbook and Chef in general:

* See the quick example in the section below.
* See the [Examples README.md](https://github.com/algosec/algosec-chef/blob/master/examples/README.md) for a full step-by-step guide that will show you how to use this cookbook and its resources.
    The README file will walk you through all the steps from installing Chef and its dependencies, to running a live example. 

##### How to execute

```bash
$ chef-client -z -o <cookbook_name>::<recipe_name> -j /full/path/to/flows.json
```

##### Cookbook Example
```ruby
# my_cookbook/metadata.rb
depends 'algosec'

algosec = { host: 'local.algosec.com', user: 'admin', password: 'algosec123' }

# Example: Define the application flows for application 'testApp'.
# Note that the application name and application flows are loaded from the external json file 
algosec_application_flows 'define application flows using a json file' do
  algosec_options algosec
  application_name node['application_name']
  application_flows node['application_flows']
end
```

##### flow.json flows definition example
```json
{
  "application_name": "testApp",
  "application_flows": {
    "flow1": {
      "sources": [
        "HR Payroll server",
        "192.168.0.0/16"
      ],
      "destinations": [
        "16.47.71.62"
      ],
      "services": [
        "HTTPS"
      ]
    },
    "flow2": {
      "sources": [
        "10.0.0.1"
      ],
      "destinations": [
        "10.0.0.2"
      ],
      "services": [
        "udp/501"
      ]
    }
  }
}
```

## Testing

For more details look at the [TESTING.md](https://github.com/algosec/algosec-chef/blob/master/TESTING.md).

All static code tests are simply run by:
```
bundle exec rake
```

To actually test the cookbook in action, please refer to the `examples/README.md` file and apply against a test app in your AlgoSec Demo VM machine. 

## License & Authors

If you would like to see the detailed LICENSE click [here](https://github.com/algosec/algosec-chef/blob/master/LICENSE).

- Author:: AlgoSec <dev@algosec.com>