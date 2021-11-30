class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: false do |t|
      t.string :name, primary_key: true, uniqueness: {case_sensitive: false}
      t.string :encrypted_password, null: false, default: ""
      t.string :cpf, unique: true
      t.string :email, unique: true

      t.timestamps
    end
  end
end