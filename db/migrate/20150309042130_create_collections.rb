class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :member_id
      t.integer :request_member_id
      t.integer :book_id
      t.float :height
      t.float :width
      t.float :depth
      t.float :weight
      t.integer :condition
      t.boolean :sunburn
      t.boolean :scratch
      t.integer :line
      t.integer :broken
      t.boolean :band
      t.boolean :cigar
      t.boolean :pet
      t.boolean :mold
      t.binary :image
      t.text :note
      t.integer :state
      t.datetime :regist_date
      t.datetime :request_date
      t.datetime :accept_date
      t.datetime :send_date
      t.datetime :receive_date
      t.binary :label
      t.integer :state

      t.timestamps
    end
  end
end
