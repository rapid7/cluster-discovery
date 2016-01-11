module Cluster
  module Discovery
    module EC2
      class AutoScaling
        def initialize(aws_region:)
          @aws_region = aws_region
        end

        # Discover EC2 Instances by AutoScaling Group
        #
        # @param [String] aws_auto_scaling_group AutoScaling Group to limit
        #  discovery by
        # @return [Array<Aws::EC2::Types::Instance>] Discovery result
        def discover(aws_asg:)
          tags = Cluster::Discovery::EC2::Tag.new(aws_region: @aws_region)
          tags.discover(aws_tags: [
            {
              key: 'tag:aws:autoscaling:groupName',
              values: [aws_asg]
            }
          ])
        end
      end
    end
  end
end
