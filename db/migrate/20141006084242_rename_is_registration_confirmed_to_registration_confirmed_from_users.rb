class RenameIsRegistrationConfirmedToRegistrationConfirmedFromUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :is_registration_confirmed, :registration_confirmed
  end
end
