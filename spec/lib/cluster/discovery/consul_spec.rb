require 'spec_helper'

describe 'Cluster::Discovery::Consul' do
  describe '.initialize' do
    context 'configuration is correct' do
      it 'has the default url' do
        consul = Cluster::Discovery::Consul.new
        config = consul.instance_variable_get(:@configuration)
        expect(config.url).to eq('http://localhost:8500')
      end

      it 'has a custom url' do
        consul = Cluster::Discovery::Consul.new(
          consul_url: 'http://127.0.0.1:8500')
        config = consul.instance_variable_get(:@configuration)
        expect(config.url).to eq('http://127.0.0.1:8500')
      end
    end
  end

  describe '.build_extra_opts' do
    before(:each) do
      @consul = Cluster::Discovery::Consul.new
    end
    context 'opts are correct without tags' do
      let(:noleader_notags) do
        [:all]
      end

      let(:leader_notags) do
        [:first]
      end

      it 'can return only leader without tags' do
        expect(
          @consul.build_extra_opts(leader: false, tags: [])
        ).to eq(noleader_notags)
      end

      it 'can return only all nodes' do
        expect(
          @consul.build_extra_opts(leader: true, tags: [])
        ).to eq(leader_notags)
      end
    end

    context 'opts are correct with tags' do
      let(:noleader_tags) do
        [:all, { tag: ['master'] }]
      end

      let(:leader_tags) do
        [:first, { tag: ['master'] }]
      end

      it 'can return only leader without tags' do
        expect(
          @consul.build_extra_opts(leader: false, tags: ['master'])
        ).to eq(noleader_tags)
      end

      it 'can return only all nodes' do
        expect(
          @consul.build_extra_opts(leader: true, tags: ['master'])
        ).to eq(leader_tags)
      end
    end
  end

  describe '.discover' do
    before(:each) do
      @consul = Cluster::Discovery::Consul.new(
        consul_url: 'http://172.28.128.104:8500')
    end

    let(:consul_notags_leader) do
      @consul.discover(consul_service: 'redis', leader: true)
    end

    let(:consul_notags_noleader) do
      @consul.discover(consul_service: 'redis')
    end

    context 'can discover leader node' do
      it 'can discover nodes without tags' do
        expect(consul_notags_leader.Address).to eq('192.168.10.10')
      end
    end
  end
end
