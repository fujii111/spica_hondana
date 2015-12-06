class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :collection_id
      t.integer :rate
      t.integer :state
      t.text :comment
      t.timestamps
    end
  end
end