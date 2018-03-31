class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :reference
      t.references :purchase_channel, foreign_key: true
      t.references :client, foreign_key: true
      t.references :delivery_service, foreign_key: true
      t.float :total_value
      t.json :line_items
      t.references :batch, foreign_key: true

      t.timestamps
    end
    add_index :orders, :reference, unique: true
  end
end
