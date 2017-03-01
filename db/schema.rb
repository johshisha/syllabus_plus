# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170228133849) do

  create_table "faculties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "year_datum_id", null: false
    t.integer  "teacher_id",    null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["year_datum_id", "teacher_id"], name: "index_subject_relationships_on_year_datum_id_and_teacher_id", unique: true, using: :btree
  end

  create_table "subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "faculty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_subjects_on_code", using: :btree
    t.index ["faculty_id"], name: "index_subjects_on_faculty_id", using: :btree
    t.index ["name"], name: "index_subjects_on_name", using: :btree
  end

  create_table "teachers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "year_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "year",                             null: false
    t.integer  "term",                             null: false
    t.text     "url",                limit: 65535
    t.integer  "number_of_students"
    t.float    "A",                  limit: 24
    t.float    "B",                  limit: 24
    t.float    "C",                  limit: 24
    t.float    "D",                  limit: 24
    t.float    "F",                  limit: 24
    t.float    "other",              limit: 24
    t.float    "mean_score",         limit: 24
    t.integer  "subject_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["A"], name: "index_year_data_on_A", using: :btree
    t.index ["B"], name: "index_year_data_on_B", using: :btree
    t.index ["C"], name: "index_year_data_on_C", using: :btree
    t.index ["D"], name: "index_year_data_on_D", using: :btree
    t.index ["F"], name: "index_year_data_on_F", using: :btree
    t.index ["mean_score"], name: "index_year_data_on_mean_score", using: :btree
    t.index ["subject_id"], name: "index_year_data_on_subject_id", using: :btree
    t.index ["term"], name: "index_year_data_on_term", using: :btree
    t.index ["year"], name: "index_year_data_on_year", using: :btree
  end

  add_foreign_key "subjects", "faculties"
  add_foreign_key "year_data", "subjects"
end
