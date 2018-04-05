class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.integer :role
      t.references :purchase_channel, foreign_key: true

      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
