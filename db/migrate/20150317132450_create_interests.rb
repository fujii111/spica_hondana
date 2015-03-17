class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :member, index: true
      t.references :genre, index: true
      t.integer :sort

      t.timestamps
    end
  end
end
