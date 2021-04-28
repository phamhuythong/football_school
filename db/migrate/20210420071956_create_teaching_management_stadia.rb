class CreateTeachingManagementStadia < ActiveRecord::Migration[6.0]
  def change
    create_table :teaching_management_stadia do |t|
      t.integer :account_id
      t.integer :stadium_id
      t.boolean :deleted, default: false
      t.integer :lock_version, default: 0
      t.index :account_id
      t.index :stadium_id

      t.timestamps
    end

    add_foreign_key :teaching_management_stadia, :accounts, column: :account_id
    add_foreign_key :teaching_management_stadia, :stadia, column: :stadium_id
  end
end
