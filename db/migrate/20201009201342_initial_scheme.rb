class InitialScheme < ActiveRecord::Migration[6.0]
  def change
    create_table :aircrafts do |t|
      t.string :name, null: false
      # yep some unnormalization
      t.integer :status, null: false
      t.datetime :last_change
    end

    add_index :aircrafts, :status, unique: false
    add_index :aircrafts, [:status, :last_change], unique: false

    create_table :histories do |t|
      t.integer :aircraft_id, null: false
      t.integer :status, null: false
      t.datetime :created_at, null: false
    end

    add_index :histories, :aircraft_id, unique: false
    add_index :histories, [:aircraft_id, :created_at], unique: false
  end
end