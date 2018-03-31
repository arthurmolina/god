class CreateDeliveryServices < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_services do |t|
      t.string :name

      t.timestamps
    end
    add_index :delivery_services, :name, unique: true
  end
end
