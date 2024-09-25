require 'rails_helper'

RSpec.describe InvestationController, type: :controller do
  let(:user) { create(:user) } # Assume you have a user factory set up
  let(:valid_price_id) { 'asd' }
  let(:mock_price_all) { double('LatestStockPrice') }

  before do
    allow(LatestStockPrice).to receive(:price_all).and_return(mock_price_all)
    session[:user_id] = user.id # Simulate a logged-in user
  end

  describe '#price' do
    let(:price_service) { instance_double(Investations::InvestationPriceService) }

    context 'when price_id is provided' do
      before do
        allow(Investations::InvestationPriceService).to receive(:new).and_return(price_service)
        allow(price_service).to receive(:price)
      end

      it 'calls the InvestationPriceService with the correct parameters' do
        post :price, params: { price_id: valid_price_id }

        expect(Investations::InvestationPriceService).to have_received(:new).with(
          results: mock_price_all,
          price_id: valid_price_id
        )
        expect(price_service).to have_received(:price)
      end
    end

    context 'when price_id is not provided' do
      let(:prices_service) { instance_double(Investations::InvestationPricesService) }

      before do
        allow(Investations::InvestationPricesService).to receive(:new).and_return(prices_service)
        allow(prices_service).to receive(:prices)
      end

      it 'calls the InvestationPricesService' do
        post :price

        expect(Investations::InvestationPricesService).to have_received(:new).with(
          results: mock_price_all,
          params: {}
        )
        expect(prices_service).to have_received(:prices)
      end
    end
  end

  describe '#prices' do
    let(:prices_service) { instance_double(Investations::InvestationPricesService) }

    before do
      allow(Investations::InvestationPricesService).to receive(:new).and_return(prices_service)
      allow(prices_service).to receive(:prices)
    end

    it 'calls the InvestationPricesService' do
      post :prices, params: {}

      expect(Investations::InvestationPricesService).to have_received(:new).with(
        results: mock_price_all,
        params: {}
      )
      expect(prices_service).to have_received(:prices)
    end
  end

  describe 'authentication' do
    before do
      session[:user_id] = nil # Simulate a logged-out user
    end

    it 'returns unauthorized status if user is not authenticated' do
      post :price, params: { price_id: valid_price_id }
      expect(response).to have_http_status(:unauthorized)

      post :prices
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
