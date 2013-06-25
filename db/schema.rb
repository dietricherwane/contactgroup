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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130622090544) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 40
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "demands", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "accepted"
    t.datetime "decision_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix"
    t.string   "msisdn"
  end

  add_index "demands", ["group_id"], :name => "index_demands_on_group_id"
  add_index "demands", ["msisdn"], :name => "index_demands_on_number"
  add_index "demands", ["prefix"], :name => "index_demands_on_prefix"
  add_index "demands", ["user_id"], :name => "index_demands_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "published"
    t.boolean  "deleted"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["user_id"], :name => "index_groups_on_user_id"

  create_table "groups_messages", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "message_id"
  end

  add_index "groups_messages", ["group_id", "message_id"], :name => "index_groups_messages_on_group_id_and_message_id"

  create_table "linklogs", :force => true do |t|
    t.boolean  "receive_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "link_id"
  end

  create_table "links", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "receive_messages"
    t.boolean  "deleted"
    t.datetime "cancellation_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adherent_id"
  end

  add_index "links", ["group_id"], :name => "index_links_on_group_id"
  add_index "links", ["user_id"], :name => "index_links_on_user_id"

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 40
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.string   "scope"
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "parameters", :force => true do |t|
    t.integer  "demand_expiration_delay"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delay_before_resending_demand"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.string   "msisdn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.date     "birthdate"
    t.boolean  "published"
    t.string   "prefix"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["msisdn"], :name => "index_users_on_msisdn"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
