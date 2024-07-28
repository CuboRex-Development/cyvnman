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

ActiveRecord::Schema[7.1].define(version: 2024_07_28_191423) do
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

  create_table "parts", force: :cascade do |t|
    t.string "part_number"
    t.string "part_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "type_name"
    t.string "type_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "drawn_by"
    t.string "checked_by"
    t.string "approved_by"
    t.date "drawn_date"
    t.index ["part_id"], name: "index_versions_on_part_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "models", "types"
  add_foreign_key "versions", "parts"
end
