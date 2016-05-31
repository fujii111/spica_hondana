class ChangeLabelToCollections < ActiveRecord::Migration
  # 変更内容
  def up
    change_column :collections, :label, :binary, limit: 10.megabyte
    change_column :collections, :image, :binary, limit: 10.megabyte
  end

  # 変更前の状態
  def down
    change_column :collections, :label, :binary
    change_column :collections, :image, :binary
  end
end