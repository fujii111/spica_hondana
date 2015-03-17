class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :inquiry_mail
      t.string :clickpost_url
      t.integer :request_limit
      t.integer :default_point

      t.timestamps
    end
  end
end
