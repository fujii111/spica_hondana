class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :member, index: true
      t.string :name
      t.string :publisher
      t.string :author
      t.string :language
      t.string :sale_date
      t.float :height
      t.float :width
      t.float :depth
      t.string :isbn
      t.text :description
      t.binary :image
      t.boolean :delete_flg

      t.timestamps
    end
  end
end
