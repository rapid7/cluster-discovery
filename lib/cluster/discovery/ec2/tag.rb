module Cluster
  module Discovery
    module EC2
      class Tag < Cluster::Discovery::EC2::Base
        # Discover EC2 Instances by Tag
        #
        # @param [Array<Hash>] aws_tags AWS Tags to limit discovery
        # @option aws_tags [String] :key The name of the tag
        # @option aws_tags [Array<String>] :values The value(s) of the tag
        # @example For example, aws_tags might look something like this:
        #  [
        #    { key: "tag:Service", values: ["MyService"] },
        #    { key: "tag:Purpose", values: ["MyPurpose"] }
        #  ]
        # @return [Type] description of returned object
        def discover(aws_tags: [])
          fail EmptyTagsError if aws_tags.empty?
          discover_instances_by_tags(build_tags(aws_tags))
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

        def discover_instances_by_tags(tags)
          instances = ec2_client.describe_instances(
            filters: tags).inject([]) do |a, page|
            a << page.reservations.map(&:instances)
          end
          instances = instances.flatten.compact
          instances.sort_by! { |x| "#{x.launch_time.to_i}-#{x.instance_id}" }
        end
      end
    end
  end
end
