require 'spec_helper'

describe 'Cluster::Discovery' do
  let(:discovery) { Cluster::Discovery }

  describe '.discover' do
    context 'has a discover method' do
      it { expect(discovery).to respond_to(:discover) }
    end
  end
end
