require_relative 'discovery/ec2/tag'
require_relative 'discovery/ec2/auto_scaling'
require_relative 'discovery/consul'
require_relative 'discovery/errors'

module Cluster
  module Discovery
    class << self
      def discover(discovery_service, *args)
        Cluster::Discovery.send(discovery_service.to_sym, :discover, args)
      end

      def ec2_tag(action, *args)
        args = args.first.first
        c = Cluster::Discovery::EC2::Tag.new(aws_region: args[:aws_region])
        c.send(action, aws_tags: args[:aws_tags])
      end

      def ec2_asg(action, *args)
        args = args.first.first
        c = Cluster::Discovery::EC2::AutoScaling.new(
          aws_region: args[:aws_region])
        c.send(action, aws_asg: args[:aws_asg])
      end

      def consul(action, args)
        args = args.first
        consul_url = args.delete(:consul_url) if args.key?(:consul_url)
        if consul_url
          c = Cluster::Discovery::Consul.new(consul_url: consul_url)
        else
          c = Cluster::Discovery::Consul.new
        end
        c.send(action, args)
      end
    end
  end
end
