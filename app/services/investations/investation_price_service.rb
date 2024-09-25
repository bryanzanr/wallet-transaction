module Investations
    # service for filter the price_all 
    class InvestationPriceService
        def initialize(results:, price_id:)
            @results = results
            @price_id = price_id
        end

        def price
            @results.each do |result|
                if result['identifier'] == @price_id
                    return result
                end
            end
        end
    end
end
