# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_20_131142) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.string "payee"
    t.string "memo"
    t.date "date"
    t.integer "amount_paid"
    t.date "reconciled_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_expenses_on_date"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.boolean "is_administrator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_expenses", force: :cascade do |t|
    t.integer "expense_id"
    t.integer "person_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cumulative_sum"
  end

  add_foreign_key "person_expenses", "expenses"
  add_foreign_key "person_expenses", "people"
end
