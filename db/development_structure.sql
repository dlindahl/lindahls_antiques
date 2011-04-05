CREATE TABLE "antiques" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "sku" varchar(255), "description" text, "width" float, "height" float, "depth" float, "weight" float, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "photos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "antique_id" integer, "width" integer, "height" integer, "title" varchar(255), "url" varchar(255), "source" varchar(255), "size" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "failed_attempts" integer DEFAULT 0, "unlock_token" varchar(255), "locked_at" datetime, "created_at" datetime, "updated_at" datetime, "admin" boolean);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110403210913');

INSERT INTO schema_migrations (version) VALUES ('20110403212358');

INSERT INTO schema_migrations (version) VALUES ('20110404215828');

INSERT INTO schema_migrations (version) VALUES ('20110405001838');