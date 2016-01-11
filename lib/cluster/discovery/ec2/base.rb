module Cluster
  module Discovery
    module EC2
      class Base
        # @!attribute [r]
        # The EC2 Client Object
        attr_reader :ec2_client

        # Initialize the EC2 Client object
        #
        # @param [String] aws_region: The aws region
        # @return [Aws::EC2::Client] The EC2 Client object
        def initialize(aws_region:)
          @ec2_client ||= Aws::EC2::Client.new(region: aws_region)
        end
      end
    end
  end
end

require 'aws-sdk'
