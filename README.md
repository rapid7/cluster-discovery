# Cluster::Discovery

This is a library that provides a generic interface to multiple cluster providers.

## Cluster Providers
Cluster providers are something that provides metadata about a collection of hosts in a cluster.  Supported proviers are as follows:

* [ ] EC2 Tags
* [ ] EC2 AutoScaling Groups
* [ ] Consul Services
* [ ] Static Lists

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cluster-discovery'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cluster-discovery

## Usage

** WIP - I think the API is going to look something like this**

Cluster::Discovery.discover('ec2_tags',
                            aws_region: 'us-east-1',
                            aws_tags: { name: 'Service', values: ['router'] })



## Contributing

1. Fork it ( https://github.com/rapid7/cluster-discovery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
