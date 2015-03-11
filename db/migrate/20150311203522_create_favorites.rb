class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :book, index: true
      t.references :member, index: true
      t.datetime :create_date

      t.timestamps
    end
  end
end
