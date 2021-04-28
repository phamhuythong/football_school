# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_20_071956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email", null: false
    t.string "username"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated"
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "status", default: "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["password_digest"], name: "index_accounts_on_password_digest"
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "accounts_roles", id: false, force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "role_id"
    t.index ["account_id", "role_id"], name: "index_accounts_roles_on_account_id_and_role_id"
    t.index ["account_id"], name: "index_accounts_roles_on_account_id"
    t.index ["role_id"], name: "index_accounts_roles_on_role_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "addressable_id"
    t.string "addressabe_type"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "ward"
    t.string "postal_code"
    t.string "address1"
    t.string "address2"
    t.string "phone"
    t.string "fax"
    t.integer "lock_version", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressabe_type"], name: "index_addresses_on_addressabe_type"
    t.index ["addressable_id"], name: "index_addresses_on_addressable_id"
  end

  create_table "course_categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "info"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stadium_id"
    t.integer "teacher_id"
    t.integer "course_category_id"
    t.string "start_time"
    t.string "end_time"
    t.date "start_date"
    t.date "end_date"
    t.integer "lock_version", default: 0
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_category_id"], name: "index_courses_on_course_category_id"
    t.index ["stadium_id"], name: "index_courses_on_stadium_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "lesson_absences", force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "student_id"
    t.string "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lock_version"
    t.boolean "deleted", default: false
    t.index ["lesson_id", "student_id"], name: "index_lesson_absences_on_lesson_id_and_student_id", unique: true
    t.index ["lesson_id"], name: "index_lesson_absences_on_lesson_id"
    t.index ["student_id"], name: "index_lesson_absences_on_student_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "course_id"
    t.date "hold_date"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lock_version"
    t.integer "attendances", limit: 2, default: 0
    t.integer "absences", limit: 2, default: 0
    t.index ["course_id", "hold_date"], name: "index_lessons_on_course_id_and_hold_date", unique: true
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "receipt_categories", force: :cascade do |t|
    t.decimal "price", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.boolean "deleted", default: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "stadia", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stadium_group_id"
    t.boolean "deleted", default: false
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stadium_group_id"], name: "index_stadia_on_stadium_group_id"
  end

  create_table "stadium_groups", force: :cascade do |t|
    t.string "name", null: false
    t.string "info"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_courses", force: :cascade do |t|
    t.integer "student_id"
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "deleted", default: false
    t.date "start_date"
    t.date "register_date"
    t.date "end_date"
    t.integer "lock_version", default: 0
    t.integer "attendances", limit: 2, default: 0
    t.integer "total_lessons", limit: 2, default: 0
    t.integer "absences", limit: 2, default: 0
    t.index ["course_id"], name: "index_student_courses_on_course_id"
    t.index ["student_id", "course_id", "start_date"], name: "student_course_start_unique", unique: true
    t.index ["student_id"], name: "index_student_courses_on_student_id"
  end

  create_table "student_receipts", force: :cascade do |t|
    t.integer "student_id"
    t.integer "course_id"
    t.integer "receipt_category_id"
    t.decimal "amount"
    t.decimal "paid"
    t.decimal "remain"
    t.string "payer"
    t.string "cashier"
    t.boolean "deleted", default: false
    t.integer "lock_version", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "receipt_date"
    t.string "receipt_no"
    t.string "book_no"
    t.string "reason"
    t.integer "total_lessons", limit: 2, default: 0
    t.integer "prepared_by"
    t.index ["course_id"], name: "index_student_receipts_on_course_id"
    t.index ["prepared_by"], name: "index_student_receipts_on_prepared_by"
    t.index ["receipt_category_id"], name: "index_student_receipts_on_receipt_category_id"
    t.index ["student_id"], name: "index_student_receipts_on_student_id"
  end

  create_table "teacher_courses", force: :cascade do |t|
    t.integer "teacher_id"
    t.integer "course_id"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_teacher_courses_on_course_id"
    t.index ["teacher_id"], name: "index_teacher_courses_on_teacher_id"
  end

  create_table "teaching_management_stadia", force: :cascade do |t|
    t.integer "account_id"
    t.integer "stadium_id"
    t.boolean "deleted"
    t.integer "lock_version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_teaching_management_stadia_on_account_id"
    t.index ["stadium_id"], name: "index_teaching_management_stadia_on_stadium_id"
  end

  create_table "teaching_manegement_stadia", force: :cascade do |t|
    t.integer "account_id"
    t.integer "stadium_id"
    t.boolean "deleted", default: false
    t.integer "lock_version", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_teaching_manegement_stadia_on_account_id"
    t.index ["stadium_id"], name: "index_teaching_manegement_stadia_on_stadium_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "code"
    t.integer "account_id"
    t.string "first_name", null: false
    t.string "last_name"
    t.string "middle_name"
    t.datetime "date_of_birth"
    t.string "gender"
    t.string "phone"
    t.string "type"
    t.integer "lock_version", default: 0
    t.boolean "deleted", default: false
    t.string "address"
    t.string "mother_name"
    t.string "mother_phone"
    t.string "father_name"
    t.string "father_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.text "image_data"
    t.index ["account_id"], name: "index_users_on_account_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "courses", "course_categories"
  add_foreign_key "courses", "stadia"
  add_foreign_key "courses", "users", column: "teacher_id"
  add_foreign_key "lesson_absences", "lessons"
  add_foreign_key "lesson_absences", "users", column: "student_id"
  add_foreign_key "lessons", "courses"
  add_foreign_key "stadia", "stadium_groups"
  add_foreign_key "student_courses", "courses"
  add_foreign_key "student_courses", "users", column: "student_id"
  add_foreign_key "student_receipts", "accounts", column: "prepared_by"
  add_foreign_key "student_receipts", "courses"
  add_foreign_key "student_receipts", "receipt_categories"
  add_foreign_key "student_receipts", "users", column: "student_id"
  add_foreign_key "teacher_courses", "courses"
  add_foreign_key "teacher_courses", "users", column: "teacher_id"
  add_foreign_key "teaching_management_stadia", "accounts"
  add_foreign_key "teaching_management_stadia", "stadia"
  add_foreign_key "teaching_manegement_stadia", "accounts"
  add_foreign_key "teaching_manegement_stadia", "stadia"
  add_foreign_key "users", "accounts"
end
