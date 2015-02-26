class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :content
      t.datetime :notice_date

      t.timestamps
    end
  end
end
