module Transactions
    # service to create user's withdraw transaction
    class TransactionWithdrawService
        def initialize(params:, user:)
            @params = params
            @user = user
        end

        def withdraw
            target_wallet = check_target_wallet_existed
            if target_wallet.present?
                deduct_target(target_wallet)
            else
                deduct_target(create_target_wallet)
            end 
        end

        private

        def check_target_wallet_existed
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

        def create_target_wallet
            Wallet.new(wallet_type: @params[:wallet_type], amount: 0)
        end

        def get_source_wallet
            Wallet.find(@params[:id])
        end

        def deduct_target(target_wallet)
            Wallet.transaction do
                amount = @params.balance
                source_wallet = get_source_wallet 
                add_source(source_wallet, target_wallet, amount)
                source_wallet.adjust_balance(amount)
                raise ActiveRecord::Rollback unless source_wallet.save
            end
        end

        def add_source(source_wallet, target_wallet, amount)
            transaction = Transaction.new(source_wallet:, target_wallet:, amount:, transaction_type: 'debit')
            transaction.validate_wallets
            transaction.validate_amount
            transaction.perform_transaction
            raise ActiveRecord::Rollback unless transaction.save
        end
    end
end
