require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { should belong_to(:wallet_id).class_name('Wallet').optional }
    it { should belong_to(:user_id).class_name('User').optional }
    it { should belong_to(:team_id).class_name('Team').optional }
  end
end
