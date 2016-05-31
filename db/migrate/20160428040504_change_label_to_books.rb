class ChangeLabelToBooks < ActiveRecord::Migration
  # 変更内容
  def up
    change_column :books, :image, :binary, limit: 10.megabyte
  end

  # 変更前の状態
  def down
    change_column :books, :image, :binary
  end
end
