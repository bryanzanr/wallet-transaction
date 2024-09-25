class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.integer :wallet_type
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
