class Wallet < ApplicationRecord
    self.inheritance_column = :wallet_type
    has_many :transactions, foreign_key: :source_wallet_id
    has_many :inbound_transactions, class_name: 'Transaction', foreign_key: :target_wallet_id
    
    validates :balance, numericality: { greater_than_or_equal_to: 0 }
    
    def adjust_balance(amount)
      self.balance += amount
    end
end

class UserWallet < Wallet
  self.wallet_type = 0
end
class TeamWallet < Wallet
  self.wallet_type = 1
end
class StockWallet < Wallet
  self.wallet_type = 2
end
