require 'spec_helper'
require 'pp'

describe 'Cluster::Discovery' do
  let(:d) { Cluster::Discovery }

  describe '.discover' do
    context 'has a discover method' do
      it { expect(d).to respond_to(:discover) }
    end
  end
end
