require 'spec_helper'

describe 'Cluster::Discovery::EC2::AutoScaling' do
  describe '.discover', vcr: true do
    context 'can reuse the tag provider' do
      before(:each) do
        @discovery = Cluster::Discovery::EC2::AutoScaling.new(
          aws_region: 'us-east-1'
        )
      end

      it 'can find instances by aws_auto_scaling_group' do
        instances = @discovery.discover(aws_asg: 'foo-prod-v000')
        instances = instances.map(&:instance_id)
        expect(instances.length).to eq(1)
      end
    end
  end
end
