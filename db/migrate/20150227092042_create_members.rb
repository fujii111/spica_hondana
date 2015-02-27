class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :login_id
      t.string :password
      t.string :reset_token
      t.datetime :reset_limit
      t.string :name
      t.string :kana
      t.string :nickname
      t.date :birthday
      t.string :mail_address
      t.string :address
      t.integer :point
      t.string :favorite_author1
      t.string :favorite_author2
      t.string :favorite_author3
      t.string :favorite_author4
      t.string :favorite_author5
      t.boolean :delete_flg

      t.timestamps
    end
  end
end
