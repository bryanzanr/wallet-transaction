require 'rails_helper'

RSpec.describe Transactions::TransactionWithdrawService do
  let(:user) { create(:user, wallet_id: user_wallet.id, team_id: team.id) }
  let(:user_wallet) { create(:user_wallet) }
  let(:team) { create(:team, wallet_id: team_wallet.id) }
  let(:team_wallet) { create(:team_wallet) }
  let(:params) { { wallet_type: 0, id: source_wallet.id, balance: 100 } }
  let(:source_wallet) { create(:wallet, balance: 500) }

  subject { described_class.new(params: params, user: user) }

  describe '#withdraw' do
    context 'when target wallet exists' do
      before do
        allow(UserWallet).to receive(:find).with(user.wallet_id).and_return(user_wallet)
        allow(user_wallet).to receive(:balance).and_return(200)
      end

      it 'calls deduct_target with existing target wallet' do
        expect(subject).to receive(:deduct_target).with(user_wallet)
        subject.withdraw
      end
    end

    context 'when target wallet does not exist' do
      before do
        allow(UserWallet).to receive(:find).and_return(nil)
        allow(subject).to receive(:create_target_wallet).and_return(user_wallet)
        allow(subject).to receive(:deduct_target).with(user_wallet)
      end

      it 'creates a new target wallet and calls deduct_target' do
        expect(subject).to receive(:create_target_wallet)
        expect(subject).to receive(:deduct_target).with(user_wallet)
        subject.withdraw
      end
    end

    context 'when wallet_type is for team' do
      let(:params) { { wallet_type: 1, id: source_wallet.id, balance: 100 } }

      before do
        allow(Team).to receive(:find).with(user.team_id).and_return(team)
        allow(TeamWallet).to receive(:find).with(team.wallet_id).and_return(team_wallet)
        allow(team_wallet).to receive(:balance).and_return(200)
      end

      it 'calls deduct_target with existing team wallet' do
        expect(subject).to receive(:deduct_target).with(team_wallet)
        subject.withdraw
      end
    end

    context 'when deducting from source wallet balance' do
      before do
        allow(UserWallet).to receive(:find).with(user.wallet_id).and_return(user_wallet)
        allow(user_wallet).to receive(:balance).and_return(200)
        allow(source_wallet).to receive(:adjust_balance)
      end

      it 'deducts from the source wallet and creates a transaction' do
        expect(subject).to receive(:add_source).and_call_original
        expect(source_wallet).to receive(:adjust_balance).with(100)
        subject.withdraw
      end
    end
  end

  describe '#check_target_wallet_existed' do
    context 'when wallet_type is 0' do
      it 'returns the user wallet' do
        expect(subject.send(:check_target_wallet_existed)).to eq(user_wallet)
      end
    end

    context 'when wallet_type is 1' do
      let(:params) { { wallet_type: 1, id: source_wallet.id, balance: 100 } }

      it 'returns the team wallet' do
        allow(Team).to receive(:find).with(user.team_id).and_return(team)
        expect(subject.send(:check_target_wallet_existed)).to eq(team_wallet)
      end
    end
  end
end
