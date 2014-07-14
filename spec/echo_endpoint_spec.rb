require 'spec_helper'

describe EchoEndpoint do
  describe 'POST /' do
    it 'returns success' do
      wpost '/'

      expect(last_response).to be_ok
      expect(json).to eq('request_id' => REQUEST_ID, 'summary' => 'Echo Success Response')
    end
  end

  describe 'POST /slow' do
    it 'returns success' do
      expect_any_instance_of(described_class).to receive(:sleep).with(5)

      wpost '/slow', 'parameters' => { 'delay' => 5 }

      expect(last_response).to be_ok
    end

    context 'when delay is absent' do
      it 'does not sleep' do
        expect_any_instance_of(described_class).to_not receive(:sleep)

        wpost '/slow'

        expect(last_response).to be_ok
      end
    end
  end
end
