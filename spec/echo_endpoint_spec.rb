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

      wpost '/slow', parameters: { delay: 5 }

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

  describe 'POST /random' do
    it 'returns 200' do
      allow_any_instance_of(described_class).to receive(:rand).with(2).and_return 0

      wpost '/random'

      expect(last_response).to be_ok
    end

    it 'returns 500' do
      allow_any_instance_of(described_class).to receive(:rand).with(2).and_return 1

      wpost '/random'

      expect(last_response.status).to eq 500
    end
  end

  describe 'POST /get_objects' do
    it 'returns bananas' do
      wpost '/get_objects', parameters: { object_type: 'bananas' }

      expect(last_response).to be_ok
      expect(json).to include('request_id' => REQUEST_ID, 'summary' => "Here are 1 x 'bananas'")
    end

    context 'when object_type is absent' do
      it 'returns error' do
        wpost '/get_objects'

        expect(last_response.status).to eq 500
        expect(json['summary']).to eq "You must send the 'object_type' parameter."
      end
    end
  end
end
