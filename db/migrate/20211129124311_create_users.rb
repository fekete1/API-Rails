class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :cpf, unique: true
      t.string :email, unique: true

      t.timestamps
    end
  end
end