class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :amount
      t.references :event, null: false, foreign_key: true
      t.references :payer, null: false, foreign_key: { to_table: :participants }
      t.boolean :paid_status

      t.timestamps
    end
  end
end
