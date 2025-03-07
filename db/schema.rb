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

ActiveRecord::Schema[7.1].define(version: 2025_03_07_093435) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "block_parts", force: :cascade do |t|
    t.integer "block_id", null: false
    t.integer "part_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_id"], name: "index_block_parts_on_block_id"
    t.index ["part_id"], name: "index_block_parts_on_part_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.string "block_number"
    t.string "block_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocks_models", id: false, force: :cascade do |t|
    t.integer "block_id", null: false
    t.integer "model_id", null: false
    t.index ["block_id"], name: "index_blocks_models_on_block_id"
    t.index ["model_id"], name: "index_blocks_models_on_model_id"
  end

  create_table "blocks_parts", id: false, force: :cascade do |t|
    t.integer "block_id", null: false
    t.integer "part_id", null: false
    t.index ["block_id"], name: "index_blocks_parts_on_block_id"
    t.index ["part_id"], name: "index_blocks_parts_on_part_id"
  end

  create_table "blocks_types", id: false, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "block_id", null: false
    t.index ["block_id", "type_id"], name: "index_blocks_types_on_block_id_and_type_id"
    t.index ["type_id", "block_id"], name: "index_blocks_types_on_type_id_and_block_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "model_code"
    t.text "description"
    t.integer "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type_id"], name: "index_models_on_type_id"
  end

  create_table "part_associations_parts", id: false, force: :cascade do |t|
    t.integer "part_id", null: false
    t.integer "part_association_id", null: false
    t.index ["part_association_id", "part_id"], name: "idx_on_part_association_id_part_id_ecb24a7dba", unique: true
    t.index ["part_id", "part_association_id"], name: "idx_on_part_id_part_association_id_dc6ff40f65", unique: true
  end

  create_table "part_relationships", force: :cascade do |t|
    t.integer "parent_part_id", null: false
    t.integer "child_part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_part_id"], name: "index_part_relationships_on_child_part_id"
    t.index ["parent_part_id", "child_part_id"], name: "index_part_relationships_on_parent_part_id_and_child_part_id", unique: true
    t.index ["parent_part_id"], name: "index_part_relationships_on_parent_part_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "part_number"
    t.string "part_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_part_id"
    t.string "material"
    t.string "nominal_size"
    t.string "part_name_eg"
    t.integer "quantity"
    t.string "image"
    t.decimal "standard_price"
    t.index ["parent_part_id"], name: "index_parts_on_parent_part_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "part_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_stocks_on_part_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "type_name"
    t.string "type_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["category"], name: "index_types_on_category"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "version_number"
    t.text "description"
    t.integer "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_path"
    t.string "scale"
    t.string "sheet_size"
    t.string "unit"
    t.date "drawn_date"
    t.integer "drawn_by_id"
    t.integer "checked_by_id"
    t.integer "approved_by_id"
    t.string "status", default: "Draft"
    t.index ["approved_by_id"], name: "index_versions_on_approved_by_id"
    t.index ["checked_by_id"], name: "index_versions_on_checked_by_id"
    t.index ["drawn_by_id"], name: "index_versions_on_drawn_by_id"
    t.index ["part_id"], name: "index_versions_on_part_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "block_parts", "blocks"
  add_foreign_key "block_parts", "parts"
  add_foreign_key "models", "types"
  add_foreign_key "part_relationships", "parts", column: "child_part_id"
  add_foreign_key "part_relationships", "parts", column: "parent_part_id"
  add_foreign_key "parts", "parts", column: "parent_part_id"
  add_foreign_key "stocks", "parts"
  add_foreign_key "versions", "parts"
  add_foreign_key "versions", "users", column: "approved_by_id"
  add_foreign_key "versions", "users", column: "checked_by_id"
  add_foreign_key "versions", "users", column: "drawn_by_id"
end
