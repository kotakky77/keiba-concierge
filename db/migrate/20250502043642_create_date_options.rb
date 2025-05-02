class CreateDateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :date_options do |t|
      t.references :event, null: false, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
