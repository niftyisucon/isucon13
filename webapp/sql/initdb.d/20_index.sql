ALTER TABLE livestream_tags ADD INDEX idx_livestream_tags_livestream_id (livestream_id);
ALTER TABLE themes ADD INDEX idx_themes_user_id (user_id);
ALTER TABLE ng_words ADD INDEX idx_ng_word_livestream_id (livestream_id, user_id, created_at DESC);
ALTER TABLE reservation_slots ADD INDEX idx_reservation_slots_start_end (start_at, end_at);
ALTER TABLE livestreams ADD INDEX idx_livestreams_user_id (user_id);
