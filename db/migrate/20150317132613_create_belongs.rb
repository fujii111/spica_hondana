class CreateBelongs < ActiveRecord::Migration
  def change
    create_table :belongs do |t|
      t.references :genre, index: true
      t.references :book, index: true
      t.integer :sort

      t.timestamps
    end
  end
end
