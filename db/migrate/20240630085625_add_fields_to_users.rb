class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :wallet_balance, :decimal, precision: 15, scale: 2, default: 0.0
  end
end
