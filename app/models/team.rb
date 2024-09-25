class Team < ApplicationRecord
    belongs_to :wallet_id, class_name: 'Wallet', optional: true
end
