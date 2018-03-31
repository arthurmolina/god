class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address

      t.timestamps
    end
    add_index :clients, :name, unique: true
  end
end
