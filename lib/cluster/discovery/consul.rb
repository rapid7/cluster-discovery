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
      def discover(consul_service:, leader: false, tags: [], healthy: true)
        scope, options = build_extra_opts(leader: leader, tags: tags)
        nodes = Diplomat::Service.get(
          consul_service,
          scope,
          options
        )
        nodes = [nodes]
        nodes.flatten!

        nodes = discover_health_nodes(nodes, consul_service) if healthy
        nodes
      end

      def discover_health_nodes(nodes, consul_service)
        nodes = filtered_healthy_nodes(nodes.map(&:Address), consul_service)
        nodes = nodes_passing_checks(nodes)
        service_response(nodes)
      end

      def filtered_healthy_nodes(node_list, consul_service)
        Diplomat::Health.service(consul_service).delete_if do |service|
          !node_list.include?(service['Node']['Address'])
        end
      end

      def nodes_passing_checks(nodes)
        nodes.delete_if do |node|
          node['Checks'].any? { |check| check['Status'] != 'passing' }
        end
      end

      def service_response(nodes) # rubocop:disable Metrics/MethodLength
        nodes.map do |node|
          n = node['Node']
          s = node['Service']
          OpenStruct.new(
            Node: n['Node'],
            Address: n['Address'],
            ServiceID: s['ID'],
            ServiceName: s['Service'],
            ServiceTags: s['Tags'],
            ServiceAddress: s['Address'],
            ServicePort: s['Port'],
            Checks: node['Checks'],
            _Node: node['Node'],
            _Service: node['Service']
          )
        end
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
require 'ostruct'
