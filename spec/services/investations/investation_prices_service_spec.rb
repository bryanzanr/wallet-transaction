require 'rails_helper'

RSpec.describe Investations::InvestationPricesService do
  describe '#prices' do
    let(:results) do
      [
        { 'identifier' => 'qwe'},
        { 'identifier' => 'asd'},
        { 'identifier' => 'zxc'},
        { 'identifier' => 'wer'},
        { 'identifier' => 'sdf'}
      ]
    end

    context 'with default pagination' do
      it 'returns the first 10 results by default' do
        service = Investations::InvestationPricesService.new(results: results, params: {})
        expect(service.prices).to eq(results)
      end
    end

    context 'with custom pagination' do
      it 'returns the first page with 2 results' do
        service = Investations::InvestationPricesService.new(results: results, params: { page: 1, per_page: 2 })
        expect(service.prices).to eq([
          { 'identifier' => 'qwe' },
          { 'identifier' => 'asd' }
        ])
      end

      it 'returns the second page with 2 results' do
        service = Investations::InvestationPricesService.new(results: results, params: { page: 2, per_page: 2 })
        expect(service.prices).to eq([
          { 'identifier' => 'zxc' },
          { 'identifier' => 'wer' }
        ])
      end

      it 'returns the third page with 2 results' do
        service = Investations::InvestationPricesService.new(results: results, params: { page: 3, per_page: 2 })
        expect(service.prices).to eq([
          { 'identifier' => 'sdf' }
        ])
      end

      it 'returns an empty array for a page out of range' do
        service = Investations::InvestationPricesService.new(results: results, params: { page: 4, per_page: 2 })
        expect(service.prices).to eq([])
      end
    end

    context 'with invalid pagination values' do
      it 'defaults to page 1 and per_page 10 if invalid page is provided' do
        service = Investations::InvestationPricesService.new(results: results, params: { page: -1, per_page: 5 })
        expect(service.prices).to eq(results)
      end

      it 'defaults to page 1 if no page is provided' do
        service = Investations::InvestationPricesService.new(results: results, params: { per_page: 3 })
        expect(service.prices).to eq([
          { 'identifier' => 'qwe' },
          { 'identifier' => 'asd' },
          { 'identifier' => 'zxc' }
        ])
      end
    end
  end
end
