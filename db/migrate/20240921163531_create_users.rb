class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.references :wallet_id, foreign_key: { to_table: :wallets }
      t.references :team_id, foreign_key: { to_table: :teams }
      t.timestamps
    end
  end
end
