class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :member, index: true
      t.datetime :notice_date
      t.string :title
      t.text :content
      t.boolean :read_flg

      t.timestamps
    end
  end
end
