class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name
      t.text :description
      t.integer :sort
      t.boolean :delete_flg

      t.timestamps
    end
  end
end
