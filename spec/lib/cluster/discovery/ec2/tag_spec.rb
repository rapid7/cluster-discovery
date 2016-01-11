require 'spec_helper'

describe 'Cluster::Discovery::EC2::Tag' do
  describe '.discover' do
    context 'not passing aws_region arg' do
      let(:discovery) { Cluster::Discovery::EC2::Tag }
      it 'requires aws_region' do
        expect { discovery.new }.to(
          raise_error(ArgumentError),
          'missing keyword: aws_region'
        )
      end
    end

    context 'passing aws_region arg', vcr: true do
      before(:each) do
        @discovery = Cluster::Discovery::EC2::Tag.new(aws_region: 'us-east-1')
      end

      it 'has a discover method' do
        expect(@discovery).to respond_to(:discover)
      end

      # FIXME: Fix the error class
      it 'tags cannot be empty' do
        skip
        expect { @discovery.discovery }.to(
          raise_error(Cluster::Discovery::EmptyTagsError),
          'Tags cannot be empty'
        )
      end

      it 'can find instances by tag' do
        instances = @discovery.discover(
          aws_tags: [{ key: 'Service', value: 'router' }]
        )
        instances = instances.map(&:instance_id)
        expect(instances.length).to eq(6)
      end
    end
  end

  describe '.build_tags', vcr: true do
    before(:each) do
      @discovery = Cluster::Discovery::EC2::Tag.new(aws_region: 'us-east-1')
    end

    let(:filters) do
      [{ name: 'instance-state-name', values: ['running'] }]
    end

    context 'parse default tags' do
      let(:tags) { @discovery.send(:build_tags) }

      it 'can format tags correctly' do
        expect(tags).to eq(filters)
      end
    end

    context 'parse input tag' do
      let(:tags) do
        @discovery.send(:build_tags,
        [{ key: 'Service', value: 'router' }])
      end

      let(:filters) do
        [
          { name: 'tag:Service', values: ['router'] },
          { name: 'instance-state-name', values: ['running'] }
        ]
      end

      it 'can format tags correctly' do
        expect(tags).to eq(filters)
      end
    end
  end
end
