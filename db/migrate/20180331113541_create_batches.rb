class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.string :reference
      t.integer :status, default: 2

      t.timestamps
    end
    add_index :batches, :reference, unique: true
  end
end
