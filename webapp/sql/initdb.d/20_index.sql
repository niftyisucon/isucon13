ALTER TABLE livestream_tags ADD INDEX idx_livestream_tags_livestream_id (livestream_id);
ALTER TABLE themes ADD INDEX idx_themes_user_id (user_id);
ALTER TABLE records ADD INDEX idx_records_disabled_name_domain_id (disabled, name, domain_id);
