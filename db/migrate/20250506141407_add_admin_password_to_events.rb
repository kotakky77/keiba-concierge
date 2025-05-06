class AddAdminPasswordToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :admin_password, :string
  end
end
