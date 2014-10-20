class AddCreatedByOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_by_omniauth, :boolean
    change_column_default :users, :created_by_omniauth, false
  end
end
