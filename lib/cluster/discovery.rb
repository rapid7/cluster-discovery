require_relative 'discovery/ec2/tag'
require_relative 'discovery/errors'

module Cluster
  module Discovery
    class << self
      def discover(discovery_service, *args)
        Cluster.send(discovery_service.to_sym, :discover, args)
      end
    end

    private

    def ec2_tag(action, *args)
      Cluster::EC2::Tag.send(action, args)
    end
  end
end
