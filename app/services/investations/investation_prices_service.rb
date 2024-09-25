module Investations
    # service for paginate the price_all 
    class InvestationPricesService
        def initialize(results:, params:)
            @results = results
            @params = params
        end

        def prices
            page = positive_integer_or_default(@params[:page], 1)
            per_page = positive_integer_or_default(@params[:per_page], 10)
            paginate_response(page, per_page)
        end

        private

        def positive_integer_or_default(value, default)
            value_i = value.to_i
            value_i.positive? value_i : default.to_i
        end

        def paginate_response(page, per_page)
            total_count = @results.length
            return @results if page.nil? && per_page.nil?

            counter = 0
            paginate_response = []
            @reports.each do |report|
                counter += 1
                next if (page - 1) * per_page >= counter

                paginate_response << report if check_per_page(page, per_page, counter)
            end
            paginate_response
        end

        def check_per_page(page, per_page, counter)
            default = page * per_page
            return default == counter if per_page == 1

            default >= counter
        end
    end
end
