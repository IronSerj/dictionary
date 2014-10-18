class AddGuestUuidToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :guest_uuid, :string
  end
end
