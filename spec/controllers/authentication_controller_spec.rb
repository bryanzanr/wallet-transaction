require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe '#sign_in' do
    let(:user_id) { '12345' }

    before do
      request.headers['user_id'] = user_id
      post :sign_in
    end

    it 'sets the session user_id' do
      expect(session[:user_id]).to eq(user_id)
    end
  end

  describe '#sign_out' do
    before do
      session[:user_id] = '12345' # Simulate a signed-in user
      post :sign_out
    end

    it 'clears the session user_id' do
      expect(session[:user_id]).to be_nil
    end
  end
end
