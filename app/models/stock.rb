class Stock < ApplicationRecord
    belongs_to :wallet_id, class_name: 'Wallet', optional: true
    belongs_to :user_id, class_name: 'User', optional: false
    belongs_to :team_id, class_name: 'Team', optional: true
end
