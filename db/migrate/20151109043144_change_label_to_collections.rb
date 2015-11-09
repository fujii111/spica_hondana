class ChangeLabelToCollections < ActiveRecord::Migration
  # 変更内容
  def up
    change_column :collections, :label, :binary, limit: 10.megabyte
  end

  # 変更前の状態
  def down
    change_column :collections, :label, :binary
  end
end