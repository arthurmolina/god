class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.string :reference
      t.references :purchase_channel, foreign_key: true
      t.integer :status

      t.timestamps
    end
    add_index :batches, :reference, unique: true
  end
end
