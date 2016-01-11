module Cluster
  module Discovery
    module EC2
      class Tag
        # @!attribute [r]
        # The EC2 Client Object
        attr_reader :ec2_client

        # Initialize the EC2 Client object
        #
        # @param [String] aws_region: The aws region
        # @return [String] description of returned object
        # FIXME: Lookup the return here
        def initialize(aws_region:)
          @ec2_client ||= Aws::EC2::Client.new(region: aws_region)
        end

        # Discover EC2 Instances by Tag
        #
        # @param [Array<Hash>] aws_tags: describe aws_tags:
        # @return [Type] description of returned object
        # FIXME This input type in complicated
        def discover(aws_tags: [])
          fail EmptyTagsError if aws_tags.empty?
          tags = build_tags(aws_tags)
          resp = ec2_client.describe_instances(filters: tags)
          instances = resp.inject([]) do |a, page|
            a << page.reservations.map(&:instances)
          end
          instances = instances.flatten.compact
          instances.sort_by! { |x| "#{x.launch_time.to_i}-#{x.instance_id}" }
        end

        private

        def default_tags
          { name: 'instance-state-name', values: ['running'] }
        end

        def build_tags(tags = [])
          unless tags.empty?
            tags.map! do |t|
              { name: "tag:#{t[:key]}", values: [t[:value]] }
            end
          end
          tags << default_tags
          tags.flatten
        end
      end
    end
  end
end

require 'aws-sdk'
