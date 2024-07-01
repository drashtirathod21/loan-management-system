class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :loan_type, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :interest_rate, precision: 5, scale: 2, default: 0.05
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :loans, :status
  end
end
