require 'spec_helper'

describe 'Cluster::Discovery' do
  let(:discovery) { Cluster::Discovery }

  describe '.discover' do
    context 'has a discover method' do
      it { expect(discovery).to respond_to(:discover) }
    end

    context 'can discover nodes', vcr: true do
      it 'discovery with consul' do
        consul = Cluster::Discovery.discover(
          'consul',
          consul_url: 'http://172.28.128.104:8500',
          consul_service: 'redis',
          leader: true,
          tags: 'master')
        expect(consul.first.Address).to eq('192.168.10.10')
      end
    end
  end
end
