class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.text :memo
      t.string :status
      t.string :url_hash
      t.datetime :confirmed_date

      t.timestamps
    end
  end
end
