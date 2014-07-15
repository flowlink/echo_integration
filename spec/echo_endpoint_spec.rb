require 'spec_helper'

describe EchoEndpoint do
  describe 'POST /' do
    it 'returns success' do
      wpost '/'

      expect(last_response).to be_ok
      expect(last_json).to eq('request_id' => REQUEST_ID, 'summary' => 'Echo Success Response')
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
      wpost '/get_objects', parameters: { object_type: 'banana' }

      expect(last_response).to be_ok
      expect(last_json).to include('request_id' => REQUEST_ID, 'summary' => "Here are 1 x 'banana'")
      expect(last_json['bananas'].size).to eq 1
      expect(last_json['bananas'][0]['status']).to eq 'awesome'
      expect(last_json['parameters']).to be nil
    end

    it 'updates last_updated_at' do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)
      original_last_updated_at = now - 10.days

      wpost '/get_objects', parameters: { object_type: 'banana', last_updated_at: original_last_updated_at }

      expect(last_response).to be_ok
      expect(last_json['parameters']['last_updated_at']).to eq now.to_s
      expect(Time.parse(last_json['parameters']['last_updated_at'])).to be > original_last_updated_at
    end

    it 'returns orders' do
      allow(Hub::Samples::Order).to receive(:object).and_return('order' => { 'status' => 'super awesome' })

      wpost '/get_objects', parameters: { object_type: 'order', quantity: 2 }

      expect(last_response).to be_ok
      expect(last_json).to include('request_id' => REQUEST_ID, 'summary' => "Here are 2 x 'order'")
      expect(last_json['orders'].size).to eq 2
      expect(last_json['orders'][0]['status']).to eq 'super awesome'
      expect(last_json['orders'][1]['status']).to eq 'super awesome'
      expect(last_json['orders'][0]['id']).to_not eq last_json['orders'][1]['id']
    end

    context 'when object_type is absent' do
      it 'returns error' do
        wpost '/get_objects'

        expect(last_response.status).to eq 500
        expect(last_json['summary']).to eq "You must send the 'object_type' parameter."
      end
    end
  end
end
