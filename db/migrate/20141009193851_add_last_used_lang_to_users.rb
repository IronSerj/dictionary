class AddLastUsedLangToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_used_lang, :string
  end
end
