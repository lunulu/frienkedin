class FixUsersAndRelations < ActiveRecord::Migration[8.0]
  def change
    rename_table :skils, :skills

    create_table :interests_users, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interest, null: false, foreign_key: true
      t.index [ :user_id, :interest_id ], unique: true
    end

    create_table :skills_users, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.index [ :user_id, :skill_id ], unique: true
    end

    add_index :users, :email, unique: true
    add_index :interests, :name, unique: true
    add_index :skills, :name, unique: true
  end
end
