require 'cluster/discovery/version'

module Cluster
  class Discovery
    def discover(discovery_service, *args)
      Cluster.send(discovery_service.to_sym, :discover, args)
    end
  end
end
