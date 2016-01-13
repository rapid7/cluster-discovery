module Cluster
  module Discovery
    class Consul
      def initialize(consul_url: nil)
        unless consul_url.nil?
          Diplomat.configure do |config|
            config.url = consul_url
          end
        end
        @configuration = Diplomat.configuration
      end

      # Discovery nodes using a Consul cluster
      #
      # @param [String] consul_service: Name of the Consul service
      # @param [Boolean] leader: (false) Fetch :all or or :first(the leader)
      # @param [Array] tags: ([]) List of tags to limit discovery by
      # @return [Struct] Object representing the Node in the service
      def discover(consul_service:, leader: false, tags: [])
        Diplomat::Service.get(
          consul_service,
          build_extra_opts(leader: leader, tags: tags)
        )
      end

      # Build args for Diplomat::Service.get
      #
      # @param [Hash] args the options to pass to Diplomat::Service.get
      # @option opts [Symbol] :leader Wheather or not to get only the leader
      # @option opts [Symbol] :tags The tags to discover by
      # @return [Array] The options to pass to Diplomat::Service.get
      def build_extra_opts(args)
        opts = []
        leader = args[:leader] == true ? :first : :all
        opts << leader
        opts << { tag: args[:tags] } unless args[:tags].empty?
        opts
      end
    end
  end
end

require 'diplomat'
