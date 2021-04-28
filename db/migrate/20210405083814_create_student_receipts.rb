class CreateStudentReceipts < ActiveRecord::Migration[6.0]
  def change
    create_table :student_receipts do |t|
      t.string :receipt_no
      t.string :book_no
      t.date :receipt_date
      t.integer :student_id
      t.integer :course_id
      t.integer :receipt_category_id
      t.decimal :amount
      t.decimal :paid
      t.decimal :remain
      t.integer :total_lessons, limit: 2, default: 0
      t.string :payer
      t.integer :prepared_by
      t.string :cashier
      t.string :reason
      t.boolean :deleted, default: false
      t.integer :lock_version, default: 0
      t.index :student_id
      t.index :course_id
      t.index :receipt_category_id
      t.index :prepared_by

      t.timestamps
    end

    add_foreign_key :student_receipts, :users, column: :student_id
    add_foreign_key :student_receipts, :courses, column: :course_id
    add_foreign_key :student_receipts, :receipt_categories, column: :receipt_category_id
    add_foreign_key :student_receipts, :accounts, column: :prepared_by
  end
end
