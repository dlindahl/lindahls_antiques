CREATE TABLE "antiques" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "sku" varchar(255), "description" text, "width" float, "height" float, "depth" float, "weight" float, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "ebay_auctions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "item_number" varchar(255), "listing_status" varchar(255), "time_left" varchar(255), "description" text, "start_price" decimal(7,2) DEFAULT 0.99, "current_price" decimal(7,2) DEFAULT 0.99, "reserve_price" decimal(7,2), "buy_it_now_price" decimal(7,2), "shipping_price" decimal(7,2), "antique_id" integer, "primary_category_id" integer, "winner_id" integer, "length" integer, "bids" integer DEFAULT 0, "hit_count" integer DEFAULT 0, "watch_count" integer DEFAULT 0, "reserve_met" boolean DEFAULT 'f', "start_time" datetime, "end_time" datetime, "date_ended" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "photos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "antique_id" integer, "width" integer, "height" integer, "title" varchar(255), "url" varchar(255), "page" varchar(255), "size" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "failed_attempts" integer DEFAULT 0, "unlock_token" varchar(255), "locked_at" datetime, "created_at" datetime, "updated_at" datetime, "admin" boolean);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110403210913');

INSERT INTO schema_migrations (version) VALUES ('20110403212358');

INSERT INTO schema_migrations (version) VALUES ('20110404215828');

INSERT INTO schema_migrations (version) VALUES ('20110405001838');

INSERT INTO schema_migrations (version) VALUES ('20110424190459');