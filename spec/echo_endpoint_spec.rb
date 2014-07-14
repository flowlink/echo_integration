require 'spec_helper'

describe EchoEndpoint do
  describe 'POST /' do
    it 'returns success' do
      wpost '/'

      expect(last_response).to be_ok
      expect(json).to eq('request_id' => REQUEST_ID, 'summary' => 'Echo Success Response')
    end
  end
end
