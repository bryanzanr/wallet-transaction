class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.references :wallet_id, foreign_key: { to_table: :wallets }
      t.timestamps
    end
  end
end
