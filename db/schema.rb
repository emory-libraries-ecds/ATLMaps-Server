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

ActiveRecord::Schema.define(version: 20170807214625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_tags", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "tag_id"
    t.index ["category_id"], name: "index_categories_tags_on_category_id"
    t.index ["tag_id"], name: "index_categories_tags_on_tag_id"
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", limit: 510
    t.string "geoserver", limit: 510
    t.string "icon", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layers", force: :cascade do |t|
    t.string "name", limit: 510
    t.string "slug", limit: 510
    t.string "keywords", limit: 510
    t.string "description", limit: 510
    t.string "url", limit: 510
    t.string "layer", limit: 510
    t.datetime "date"
    t.string "layer_type", limit: 510
    t.integer "minzoom"
    t.integer "maxzoom"
    t.decimal "minx", precision: 10, scale: 8
    t.decimal "miny", precision: 10, scale: 8
    t.decimal "maxx", precision: 10, scale: 8
    t.decimal "maxy", precision: 10, scale: 8
    t.boolean "active"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layers_tags", id: false, force: :cascade do |t|
    t.integer "layer_id"
    t.integer "tag_id"
  end

  create_table "logins", force: :cascade do |t|
    t.string "identification", null: false
    t.string "password_digest"
    t.string "oauth2_token", null: false
    t.string "uid"
    t.string "single_use_oauth2_token"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "provider"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.index ["user_id"], name: "index_logins_on_user_id"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.geometry "polygon", limit: {:srid=>0, :type=>"multi_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", limit: 510, null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", limit: 510
    t.index ["token"], name: "oauth_access_grants_token_key", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", limit: 510, null: false
    t.string "refresh_token", limit: 510
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes", limit: 510
    t.index ["refresh_token"], name: "oauth_access_tokens_refresh_token_key", unique: true
    t.index ["token"], name: "oauth_access_tokens_token_key", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", limit: 510, null: false
    t.string "uid", limit: 510, null: false
    t.string "secret", limit: 510, null: false
    t.text "redirect_uri", null: false
    t.string "scopes", limit: 510, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "oauth_applications_uid_key", unique: true
  end

  create_table "projectlayers", force: :cascade do |t|
    t.integer "layer_id"
    t.integer "project_id"
    t.integer "position"
    t.string "marker", limit: 510
    t.string "layer_type", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", limit: 510
    t.string "description", limit: 500
    t.decimal "center_lat", precision: 10, scale: 8, default: "33.754401", null: false
    t.decimal "center_lng", precision: 10, scale: 8, default: "-84.38981", null: false
    t.integer "zoom_level", default: 13, null: false
    t.string "default_base_map", limit: 510, default: "street", null: false
    t.boolean "saved"
    t.boolean "published"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "featured", default: false
    t.text "intro"
    t.text "media"
    t.integer "template_id"
    t.string "card", limit: 255
    t.string "photo"
    t.index ["template_id"], name: "index_projects_on_template_id"
  end

  create_table "raster_layer_projects", force: :cascade do |t|
    t.integer "raster_layer_id"
    t.integer "project_id"
    t.integer "marker"
    t.string "data_format", limit: 510
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["raster_layer_id"], name: "index_raster_layer_projects_on_raster_layer_id"
  end

  create_table "raster_layers", force: :cascade do |t|
    t.string "name", limit: 510
    t.string "keywords", limit: 510
    t.text "description"
    t.string "workspace", limit: 510
    t.string "title", limit: 510
    t.datetime "date"
    t.string "data_format", limit: 510
    t.integer "minzoom"
    t.integer "maxzoom"
    t.decimal "minx", precision: 100, scale: 8
    t.decimal "miny", precision: 100, scale: 8
    t.decimal "maxx", precision: 100, scale: 8
    t.decimal "maxy", precision: 100, scale: 8
    t.boolean "active"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.string "data_type", limit: 255
    t.geometry "boundingbox", limit: {:srid=>0, :type=>"geometry"}
    t.string "thumb"
    t.string "attribution"
    t.index ["boundingbox"], name: "index_raster_layers_on_boundingbox", using: :gist
    t.index ["institution_id"], name: "index_raster_layers_on_institution_id"
  end

  create_table "raster_layers_tags", force: :cascade do |t|
    t.integer "raster_layer_id"
    t.integer "tag_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "heading", limit: 255
    t.string "loclink", limit: 255
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tags_vector_layers", force: :cascade do |t|
    t.integer "vector_layer_id"
    t.integer "tag_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "user_taggeds", force: :cascade do |t|
    t.integer "raster_layer_id"
    t.integer "vector_layer_id"
    t.integer "tag_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["raster_layer_id"], name: "index_user_taggeds_on_raster_layer_id"
    t.index ["tag_id"], name: "index_user_taggeds_on_tag_id"
    t.index ["user_id"], name: "index_user_taggeds_on_user_id"
    t.index ["vector_layer_id"], name: "index_user_taggeds_on_vector_layer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 510
    t.string "displayname", limit: 510
    t.string "email", default: ""
    t.integer "institution_id"
    t.string "avatar", limit: 510
    t.string "twitter", limit: 510
    t.boolean "admin"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 510
    t.string "last_sign_in_ip", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "users_email_key", unique: true
  end

  create_table "vector_features", force: :cascade do |t|
    t.string "name"
    t.json "properties"
    t.string "geometry_type"
    t.geometry "geometry_collection", limit: {:srid=>0, :type=>"geometry_collection"}
    t.integer "vector_layer_id"
    t.index ["vector_layer_id"], name: "belongs_to_vector_layer"
    t.index ["vector_layer_id"], name: "index_vector_features_on_vector_layer_id"
  end

  create_table "vector_layer_projects", force: :cascade do |t|
    t.integer "vector_layer_id"
    t.integer "project_id"
    t.integer "marker"
    t.string "data_format", limit: 510
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["vector_layer_id"], name: "index_vector_layer_projects_on_vector_layer_id"
  end

  create_table "vector_layers", force: :cascade do |t|
    t.string "name", limit: 510
    t.string "keywords", limit: 510
    t.text "description"
    t.string "url", limit: 500
    t.datetime "date"
    t.string "data_format", limit: 510
    t.integer "minzoom"
    t.integer "maxzoom"
    t.decimal "minx", precision: 100, scale: 8
    t.decimal "miny", precision: 100, scale: 8
    t.decimal "maxx", precision: 100, scale: 8
    t.decimal "maxy", precision: 100, scale: 8
    t.boolean "active"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.string "title", limit: 255
    t.string "data_type", limit: 255
    t.geometry "boundingbox", limit: {:srid=>4326, :type=>"st_polygon"}
    t.string "attribution"
    t.index ["institution_id"], name: "index_vector_layers_on_institution_id"
  end

  add_foreign_key "vector_features", "vector_layers", name: "belongs_to_vector_layer"
end
