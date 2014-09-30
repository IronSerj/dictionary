class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :user_id
      t.string :lang
      t.string :text
      t.string :translations
      t.string :synonyms
      t.string :means
      t.string :examples

      t.timestamps
    end
  end
end
