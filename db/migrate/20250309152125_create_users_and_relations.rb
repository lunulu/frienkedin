class CreateUsersAndRelations < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :patronymic
      t.string :email
      t.integer :age
      t.string :nationality
      t.string :country
      t.string :gender
      t.timestamps
    end

    create_table :interests do |t|
      t.string :name
      t.timestamps
    end

    create_table :skils do |t|
      t.string :name
      t.timestamps
    end
  end
end
