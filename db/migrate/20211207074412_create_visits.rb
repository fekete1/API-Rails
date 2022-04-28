class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.datetime :date
      t.integer :status, default: 0
      t.integer :user_id
      t.datetime :checkin_at, default: nil
      t.datetime :checkout_at, default: nil

      t.timestamps
    end
    add_foreign_key :visits, :users, column: :user_id, primary_key: "id"
  end
end
