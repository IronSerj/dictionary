class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :authentication_uid
      t.string :authentication_type

      t.timestamps
    end
  end
end
