class Transaction < ApplicationRecord
    belongs_to :source_wallet, class_name: 'Wallet', optional: false
    belongs_to :target_wallet, class_name: 'Wallet', optional: false
    
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validate :validate_wallets
  
    before_create :perform_transaction
    
    private
    
    def validate_wallets
        if transaction_type == 'credit' && target_wallet.nil?
            errors.add(:target_wallet, "must be present for deposit transaction")
        elsif transaction_type == 'debit' && source_wallet.nil?
            errors.add(:source_wallet, "must be present for withdraw transaction")
        end
    end

    def validate_amount
        if transaction_type == 'credit' && target_wallet.balance < amount
            errors.add(:target_wallet, "must have balance equal or higher than transaction amount for executing deposit")
        elsif transaction_type == 'debit' && source_wallet.balance < amount
            errors.add(:source_wallet, "must have balance equal or higher than transaction amount for executing withdraw")
        end
    end
  
    def perform_transaction
        ActiveRecord::Base.transaction do
            if transaction_type == 'debit'
                target_wallet.adjust_balance(-amount)
            elsif transaction_type == 'credit'
                source_wallet.adjust_balance(amount)
            end
        end
    end
end
