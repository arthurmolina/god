class CreatePurchaseChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_channels do |t|
      t.string :name

      t.timestamps
    end
    add_index :purchase_channels, :name, unique: true
  end
end
