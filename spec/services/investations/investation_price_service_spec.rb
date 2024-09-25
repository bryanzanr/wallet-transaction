require 'rails_helper'

RSpec.describe Investations::InvestationPriceService do
  describe '#price' do
    let(:results) do
      [
        { 'identifier' => 'asd'},
        { 'identifier' => 'qwe'},
        { 'identifier' => 'zxc'}
      ]
    end

    context 'when the price_id matches an identifier' do
      it 'returns the corresponding result' do
        service = Investations::InvestationPriceService.new(results: results, price_id: 'qwe')
        expect(service.price).to eq({ 'identifier' => 'qwe'})
      end
    end

    context 'when the price_id does not match any identifier' do
      it 'returns nil' do
        service = Investations::InvestationPriceService.new(results: results, price_id: 'wer')
        expect(service.price).to be_nil
      end
    end

    context 'when results are empty' do
      it 'returns nil' do
        service = Investations::InvestationPriceService.new(results: [], price_id: 'asd')
        expect(service.price).to be_nil
      end
    end
  end
end
