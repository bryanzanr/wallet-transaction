class InvestationController < ActionController:Base

    before_action :authenticate_user

    def price
        if params.key?('price_id')
            service = Investations::InvestationPriceService.new(
                results: price_all,
                price_id: params['price_id']
            )
            service.price
        else
            prices
        end
    end

    def prices
        service = Investations::InvestationPricesService.new(
            results: price_all,
            params:,
        )
        service.prices
    end

    def price_all
        LatestStockPrice.price_all
    end

    private
    
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def authenticate_user!
        render json: nil, status: :unauthorized unless current_user
    end

end
