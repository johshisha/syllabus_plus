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

ActiveRecord::Schema.define(version: 20170317140159) do

  create_table "faculties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",          null: false
    t.string   "code",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "syllabus_code"
  end

  create_table "subject_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "year_datum_id", null: false
    t.integer  "teacher_id",    null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["year_datum_id", "teacher_id"], name: "index_subject_relationships_on_year_datum_id_and_teacher_id", unique: true, using: :btree
  end

  create_table "subject_scores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "subject_id"
    t.float    "A",                  limit: 24
    t.float    "B",                  limit: 24
    t.float    "C",                  limit: 24
    t.float    "D",                  limit: 24
    t.float    "F",                  limit: 24
    t.float    "other",              limit: 24
    t.float    "mean_score",         limit: 24
    t.float    "weighted_score",     limit: 24
    t.integer  "number_of_students"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["A"], name: "index_subject_scores_on_A", using: :btree
    t.index ["B"], name: "index_subject_scores_on_B", using: :btree
    t.index ["C"], name: "index_subject_scores_on_C", using: :btree
    t.index ["D"], name: "index_subject_scores_on_D", using: :btree
    t.index ["F"], name: "index_subject_scores_on_F", using: :btree
    t.index ["mean_score"], name: "index_subject_scores_on_mean_score", using: :btree
    t.index ["number_of_students"], name: "index_subject_scores_on_number_of_students", using: :btree
    t.index ["subject_id"], name: "index_subject_scores_on_subject_id", using: :btree
    t.index ["weighted_score"], name: "index_subject_scores_on_weighted_score", using: :btree
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

  create_table "summarized_subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.string  "code"
    t.integer "number_of_students"
    t.float   "A",                  limit: 24
    t.float   "B",                  limit: 24
    t.float   "C",                  limit: 24
    t.float   "D",                  limit: 24
    t.float   "F",                  limit: 24
    t.float   "other",              limit: 24
    t.float   "mean_score",         limit: 24
    t.float   "weighted_score",     limit: 24
    t.integer "faculty_id"
    t.integer "subject_id"
    t.text    "url",                limit: 65535
    t.integer "term"
    t.integer "place"
    t.integer "credit"
    t.integer "teacher_id"
    t.string  "teacher_name"
    t.index ["A"], name: "index_summarized_subjects_on_A", using: :btree
    t.index ["B"], name: "index_summarized_subjects_on_B", using: :btree
    t.index ["C"], name: "index_summarized_subjects_on_C", using: :btree
    t.index ["D"], name: "index_summarized_subjects_on_D", using: :btree
    t.index ["F"], name: "index_summarized_subjects_on_F", using: :btree
    t.index ["code"], name: "index_summarized_subjects_on_code", using: :btree
    t.index ["faculty_id"], name: "index_summarized_subjects_on_faculty_id", using: :btree
    t.index ["mean_score"], name: "index_summarized_subjects_on_mean_score", using: :btree
    t.index ["name"], name: "index_summarized_subjects_on_name", using: :btree
    t.index ["number_of_students"], name: "index_summarized_subjects_on_number_of_students", using: :btree
    t.index ["subject_id"], name: "index_summarized_subjects_on_subject_id", using: :btree
    t.index ["weighted_score"], name: "index_summarized_subjects_on_weighted_score", using: :btree
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

  add_foreign_key "subject_scores", "subjects"
  add_foreign_key "subjects", "faculties"
  add_foreign_key "summarized_subjects", "faculties"
  add_foreign_key "summarized_subjects", "subjects"
  add_foreign_key "year_data", "subjects"
end
