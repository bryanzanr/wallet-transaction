class TransactionConroller < ActionController:Base
    
    before_action :authenticate_user

    def withdraw
        params = wallet_params.compact
        service = Transactions::TransactionWithdrawService.new(
            params:,
            user: @current_user
        )
        service.withdraw
    end

    def deposit
        params = wallet_params.compact
        service = Transactions::TransactionDepositService.new(
            params:,
            user: @current_user
        )
        service.deposit
    end

    private
    
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def authenticate_user!
        render json: nil, status: :unauthorized unless current_user
    end

    def wallet_params
        params.require(:wallet)
            .permit(:id, :wallet_type, :balance)
    end
end
