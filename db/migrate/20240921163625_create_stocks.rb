class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.references :wallet_id, foreign_key: { to_table: :wallets }
      t.references :user_id, foreign_key: { to_table: :users }
      t.references :team_id, foreign_key: { to_table: :teams }
      t.timestamps
    end
  end
end
