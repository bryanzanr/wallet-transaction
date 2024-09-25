require 'rails_helper'

RSpec.describe TransactionController, type: :controller do
  let(:user) { create(:user) } # Assume you have a user factory set up
  let(:valid_wallet_params) { { id: 1, wallet_type: 0, balance: 100 } }
  let(:invalid_wallet_params) { { id: -1, wallet_type: 1, balance: 200 } }

  before do
    session[:user_id] = user.id # Simulate a logged-in user
    @current_user = user
  end

  describe '#withdraw' do
    let(:withdraw_service) { instance_double(Transactions::TransactionWithdrawService) }

    before do
      allow(Transactions::TransactionWithdrawService).to receive(:new).and_return(withdraw_service)
    end

    it 'calls the withdraw method on the service with valid params' do
      allow(withdraw_service).to receive(:withdraw)

      post :withdraw, params: { wallet: valid_wallet_params }

      expect(Transactions::TransactionWithdrawService).to have_received(:new).with(
        params: valid_wallet_params.compact,
        user: @current_user
      )
      expect(withdraw_service).to have_received(:withdraw)
    end

    it 'does not call the service with invalid params' do
      expect {
        post :withdraw, params: { wallet: invalid_wallet_params }
      }.not_to change { Transactions::TransactionWithdrawService }
    end
  end

  describe '#deposit' do
    let(:deposit_service) { instance_double(Transactions::TransactionDepositService) }

    before do
      allow(Transactions::TransactionDepositService).to receive(:new).and_return(deposit_service)
    end

    it 'calls the deposit method on the service with valid params' do
      allow(deposit_service).to receive(:deposit)

      post :deposit, params: { wallet: valid_wallet_params }

      expect(Transactions::TransactionDepositService).to have_received(:new).with(
        params: valid_wallet_params.compact,
        user: @current_user
      )
      expect(deposit_service).to have_received(:deposit)
    end

    it 'does not call the service with invalid params' do
      expect {
        post :deposit, params: { wallet: invalid_wallet_params }
      }.not_to change { Transactions::TransactionDepositService }
    end
  end

  describe 'authentication' do
    before do
      session[:user_id] = nil # Simulate a logged-out user
    end

    it 'returns unauthorized status if user is not authenticated' do
      post :withdraw, params: { wallet: valid_wallet_params }
      expect(response).to have_http_status(:unauthorized)

      post :deposit, params: { wallet: valid_wallet_params }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
