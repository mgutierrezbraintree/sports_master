CREATE INDEX receipt_id ON sm_checks (CHECK_CODE);
ALTER TABLE sm_checks ADD INDEX (CLIENT_REG_CODE);

SELECT * FROM sm_checks;
SELECT * FROM sm_communication;
CREATE INDEX client_id ON sm_communication (CLIENT_REG_CODE); ##
CREATE INDEX action_id ON sm_promo_sprav (CODE); ##
-- ALTER TABLE sm_promo_sprav ADD PRIMARY KEY (CODE);  
ALTER TABLE sm_communication ADD INDEX (ACTION_CODE); ##
CREATE INDEX client_id ON sm_bonus_nach (CLIENT_REG_CODE); ##
ALTER TABLE sm_bonus_nach ADD INDEX (ACTION_CODE); ##
ALTER TABLE sm_bonus_nach ADD INDEX (CHECK_CODE); ##
CREATE INDEX client_id ON sm_bonus_spis (CLIENT_REG_CODE); ##
ALTER TABLE sm_bonus_spis ADD INDEX (ACTION_CODE); ##
ALTER TABLE sm_bonus_spis ADD INDEX (CHECK_CODE); ##
ALTER TABLE sm_checks ADD INDEX (SHOP); ##
ALTER TABLE sm_checks ADD INDEX (ART); ##
CREATE INDEX product_id ON sm_catalog (ART); ##
ALTER TABLE sm_clients ADD INDEX (PLACE_SHOP); ##
CREATE INDEX receipt ON sm_check_discount (CHECK_CODE);  ##
ALTER TABLE sm_check_discount ADD INDEX (DISC_ID); ##
CREATE INDEX shop_id ON sm_shops_visitors (SHOP);


SELECT * FROM sm_shops_visitors;