require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should belong_to(:wallet_id).class_name('Wallet').optional }
  end
end
