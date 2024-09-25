module Transactions
    # service to create user's deposit transaction
    class TransactionDepositService
        def initialize(params:, user:)
            @params = params
            @user = user
        end

        def deposit
            source_wallet = check_source_wallet_existed
            if source_wallet.present?
                add_source(source_wallet)
            else
                add_source(create_source_wallet)
            end 
        end

        private

        def check_source_wallet_existed
            case @params[:wallet_type]
            when 0
                user_wallet_id = @user.wallet_id
                return UserWallet.find(user_wallet_id) if user_wallet_id.present?

            when 1
                user_team_id = @user.team_id
                team = Team.find(user_team_id) if user_team_id.present?
                return TeamWallet.find(team.wallet_id) if team.present?

            when 2
                user_team_id = @user.team_id
                if user_team_id.present?
                    team = Team.find(user_team_id)
                    stock = Stock.find(team_id: team.id) if team.present?
                    return StockWallet.find(stock.wallet_id) if stock.present?
                    
                end
                stock = Stock.find(user_id: @user.id)
                return StockWallet.find(stock.wallet_id) if stock.present?

            else
                user_wallet_id = @user.wallet_id
                return UserWallet.find(user_wallet_id) if user_wallet_id.present?
            end
        end

        def create_source_wallet
            Wallet.new(wallet_type: @params[:wallet_type], amount: 0)
        end

        def get_target_wallet
            Wallet.find(@params[:id])
        end

        def add_source(source_wallet)
            Wallet.transaction do
                amount = @params.balance
                target_wallet = get_target_wallet 
                deduct_target(source_wallet, target_wallet, amount)
                target_wallet.adjust_balance(-amount)
                raise ActiveRecord::Rollback unless target_wallet.save
            end
        end

        def deduct_target(source_wallet, target_wallet, amount)
            transaction = Transaction.new(source_wallet:, target_wallet:, amount:, transaction_type: 'credit')
            transaction.validate_wallets
            transaction.validate_amount
            transaction.perform_transaction
            raise ActiveRecord::Rollback unless transaction.save
        end
    end
end
