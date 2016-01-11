require 'spec_helper'

describe 'Cluster::Discovery::EC2::Base' do
  describe '.ec2_client', vcr: true do
    context 'can init ec2 client' do
      before(:each) do
        class TestEC2Base < Cluster::Discovery::EC2::Base
        end
        @ec2 = TestEC2Base.new(aws_region: 'us-east-1')
      end

      it 'has ec2_client' do
        expect(@ec2).to respond_to(:ec2_client)
      end
    end
  end
end
