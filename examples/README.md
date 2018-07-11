## Examples

The main README shows a few details about the resources in this cookbook, but mainly includes code to demonstrate the properties you can set on a resource.
As such, many of those code "examples" are incomplete or contain much more than you'd want to use.
This directory contains example recipes to show real, working code and detailed comments about how the resources work, why you'd want to use certain properties, and how to tie some of the resources together.


## TL;DR

To just get an example cookbook up and running without diving into all the details and explanations, just check the fully prepared example folder [README.md](algosec-chef-example/README.md)

## Getting started

This section will help you get started using the AlgoSec cookbook, and in doing so, explain some key concepts pertaining to Chef.


### A quick intro of Chef

Chef is a configuration management tool that uses a declarative syntax. It is different than scripting in a few ways, but mainly:

     - You define what the environment should look like, not how to do it. This removes a lot of complexity, and simplifies your configuration code.
     - Chef code lives primarily in recipes. 1 or more recipes are packages into a cookbook that has a single concern. Cookbooks are versioned and checked into source control, unlike many scripts.
     - Chef integrates with a whole host of tools that make testing easy and meaningful. ChefSpec, InSpec, and Test Kitchen are some of these tools. Just like your applications, you can test and release your configuration code using automated pipelines.

Some common reasons you'd want (or need) to use a configuration management tool like Chef are to have success at scale, increase consistency, and gain visibility into your environment.


### Developing with Chef and AlgoSec

#### Step by step walkthrough to create your cookbook

If you're new to Chef, I'd encourage you to go through some of the tutorials and self-paced trainings at [learn.chef.io](https://learn.chef.io) before going any further.

About the only thing you'll need to get started developing is some basic terminal knowledge and the [ChefDK](https://downloads.chef.io/chef-dk/) installed. This will give you Ruby, as well as tools such as Berkshelf, Test Kitchen, ChefSpec, Foodcritic, and Rubocop. For this guide, we'll use a Bash terminal; if you're on Windows, you may have to modify some of the system commands accordingly.

1. To get started, we'll create a new directory named `algosec-chef-example`; this is where we'll put our new cookbooks. Also in this directory, lives the `.chef/knife.rb` configuration file used to connect to a Chef server.

  ```bash
  $ mkdir algosec-chef-example
  $ cd algosec-chef-example
  ```
2. We'll create a directory within our algosec-chef-example named cookbooks, where our cookbooks will live:

  ```bash
  $ mkdir cookbooks
  $ cd cookbooks
  ```

3. Now we can use the chef command to generate a new cookbook named 'my_algosec':
  
  ```bash
  $ chef generate cookbook my_algosec
  $ cd my_algosec
  ```
  * If you examine what was created (`$ ls -lah`), you'll notice a few files, notably `metadata.rb` and `recipes/default.rb`

4. At this point, read the main README of this repo. Much of what comes next is already described there, and we will not repeat everything here.

5. The first thing we need to do is specify a dependency on the algosec cookbook. Add the following to the end of your `metadata.rb` file:
  ```ruby
  depends 'algosec'
  ```
  * :pushpin: **Tip:** Check out the [Chef docs](https://docs.chef.io/config_rb_metadata.html) to see what all else you can put in this `metadata.rb` file.

6. Now we can edit our first recipe and add some configuration. Open up `recipes/default.rb` and add:

  ```ruby
    # Replace these credentials with those of your AlgoSec(s)
        algosec = { host: 'local.algosec.com', user: 'admin', password: 'algosec', ssl_enabled: false }
    
        algosec_application_flows 'define new application flows using a json file' do
          algosec_options algosec
          application_name node['application_name']
          application_flows node['application_flows']
      end
  ```
  * There's a few things I want to note here. The first thing is that the `algosec` object is just a Ruby hash. This hash contain the necessary data for connecting to the AlgoSec we want to manage. We put this information in clear text here, but you'll definitely want to make some changes in production code, so you're not checking passwords into a repo in clear text. You can build this hash by reading in a file, fetching an encrypted databag, etc. Also, instead of setting ssl_enabled to false, you should import the server's certs onto your machine.
  * The second thing I want to note is the `algosec_application_flows` resource. Here we're just defining a set of application flows for a specific BusinessFlow application. You can run the recipe over and over, and it will continue to check if any changes are needed for the application flows on the server to match their definition in the cookbook. 

7. In a new file `my_algosec/flows.json` paste the following configuration for the application name and application flows to define for that application.
    Modify this configuration as you wish
    
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
        },
        "flow3": {
          "sources": [
            "1.2.3.4"
          ],
          "destinations": [
            "3.4.5.6"
          ],
          "services": [
            "SSH"
          ]
        }
      }
    }
    ```
8. Now let's run our recipe and see what happens:

  ```bash
  $ cd ../
  $ chef-client -z -o my_algosec::default -j `pwd`/my_algosec/flows.json
  ```

  * You'll see an error saying it can't find the correct cookbook. This is because we haven't told Chef where to find our cookbooks, and we haven't downloaded our cookbook dependencies (algosec). Fix this by creating a `knife.rb` file at `algosec-chef-example/.chef/knife.rb` and adding the needed configuration:
        
  * Create the `.chef` folder:
    ```bash
    $ cd ../
    # (Now we're in algosec-chef-example)
    $ mkdir .chef
    ```
    
  * Now create the `.chef/knife.rb` file and add this content to it:
  
    ```ruby
    # See http://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

    current_dir = File.dirname(__FILE__)
    cookbook_path            ["#{current_dir}/../cookbooks"]

    # If you're behind a proxy, you'll need to set the http_proxy environment variable or set the http_proxy option here
    ```
        
  * And download the algosec cookbook by running:
  
    ```bash
    $ cd cookbooks
    # (Now we're in algosec-chef-example/cookbooks)
    
    $ knife cookbook site download algosec
    
    # Now we need to untar the download:
    $ tar -xvf algosec-*.tar.gz
    # Now the algosec cookbook lives at algosec-chef-example/cookbooks/algosec
    
    # You can remove the tar file if you'd like; we no longer need it
    $ rm algosec-*.tar.gz
    ```

9. Now re-run `$ chef-client -z -o my_algosec::default -j `pwd`/my_algosec/flows.json`. This time it should succeed, and if you log into your AlgoSecs, you'll see the user 'bob'.

    _NOTE_: You can see how upon first run, AlgoSec ruby SDK will be automatically downloaded and installed.

That's it! You can re-run the recipe as many times as you'd like, adding or changing properties, and it will ensure what you set in the recipe is reflected on the AlgoSec.
You can update the password, add permissions, or create additional resources.

Now that you've gotten your feet wet, please take another look at the main [README](../README.md) to see the complete list of resources available to you, as well as the recipes in this directory for examples of how to use them.
