class CreateAuthorsAndBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.text :bio

      t.timestamps
    end

    add_index :authors, :name, unique: true

    create_table :books do |t|
      t.references :author, null: false, foreign_key: true
      t.string :isbn, null: false
      t.string :title, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :stock_quantity, default: 0, null: false

      t.timestamps
    end

    add_index :books, :isbn, unique: true
  end
end
