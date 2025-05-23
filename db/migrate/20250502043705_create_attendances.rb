class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :date_option, null: false, foreign_key: true
      t.string :status
      t.text :comment

      t.timestamps
    end
  end
end
