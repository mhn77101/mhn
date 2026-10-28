-- HEALTH TOURS | REBUILT CLEAN INSTALL | v2.1 | 2026-10-28
-- Public repository: mhn77101/mhn
-- THIS IS A NEW RECONSTRUCTION, NOT THE UNRECOVERABLE DEEP RESEARCH SQL.
-- For a dedicated, correctly selected EMPTY database in Hostinger phpMyAdmin.
-- WARNING: The DROP TABLE section deletes matching tables and all their data.
-- EXPORT A FULL BACKUP BEFORE IMPORT. DO NOT RUN ON A DATABASE WITH DATA TO KEEP.
-- No doctor identities, medical tourism licenses, clinic services, prices, or translations are invented.
-- All generic offerings, clinical profiles, FAQ, blogs and SEO pages remain in draft/review.
-- An application must filter status='published' before rendering/indexing.
-- Source URLs below are unverified leads; checked_on is NULL until manually verified.
-- Tested: generated seed cardinalities and file round-trip; NOT executed on MySQL server.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS offering_editorial_drafts;

DROP TABLE IF EXISTS `audit_logs`;

DROP TABLE IF EXISTS `admins`;

DROP TABLE IF EXISTS `consultation_requests`;

DROP TABLE IF EXISTS `contact_inquiries`;

DROP TABLE IF EXISTS `bookings`;

DROP TABLE IF EXISTS `package_items`;

DROP TABLE IF EXISTS `packages`;

DROP TABLE IF EXISTS `editorial_todos`;

DROP TABLE IF EXISTS `image_metadata`;

DROP TABLE IF EXISTS `media_assets`;

DROP TABLE IF EXISTS `blog_translations`;

DROP TABLE IF EXISTS `blogs`;

DROP TABLE IF EXISTS `seo_alternates`;

DROP TABLE IF EXISTS `structured_data`;

DROP TABLE IF EXISTS `seo_records`;

DROP TABLE IF EXISTS `price_benchmarks`;

DROP TABLE IF EXISTS `prices`;

DROP TABLE IF EXISTS `doctor_verifications`;

DROP TABLE IF EXISTS `facility_verifications`;

DROP TABLE IF EXISTS `clinic_doctors`;

DROP TABLE IF EXISTS `clinic_treatments`;

DROP TABLE IF EXISTS `doctors`;

DROP TABLE IF EXISTS `clinics`;

DROP TABLE IF EXISTS `faqs`;

DROP TABLE IF EXISTS `treatment_faqs`;

DROP TABLE IF EXISTS `treatment_profiles`;

DROP TABLE IF EXISTS `translations`;

DROP TABLE IF EXISTS `offerings`;

DROP TABLE IF EXISTS `treatments`;

DROP TABLE IF EXISTS `cities`;

DROP TABLE IF EXISTS `countries`;

DROP TABLE IF EXISTS `currencies`;

DROP TABLE IF EXISTS `languages`;

DROP TABLE IF EXISTS `research_references`;

DROP TABLE IF EXISTS `site_settings`;

DROP TABLE IF EXISTS `schema_migrations`;

SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE schema_migrations (version VARCHAR(80) NOT NULL PRIMARY KEY, applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE site_settings (setting_key VARCHAR(120) NOT NULL PRIMARY KEY, setting_value TEXT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE languages (code VARCHAR(12) NOT NULL PRIMARY KEY, name VARCHAR(100) NOT NULL, native_name VARCHAR(100) NOT NULL, is_rtl TINYINT(1) NOT NULL DEFAULT 0, enabled TINYINT(1) NOT NULL DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE currencies (code CHAR(3) NOT NULL PRIMARY KEY, name VARCHAR(100) NOT NULL, symbol VARCHAR(20) NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE countries (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, code CHAR(2) NOT NULL, slug VARCHAR(150) NOT NULL, name VARCHAR(160) NOT NULL, currency_code CHAR(3) NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_country_code(code), UNIQUE KEY uq_country_slug(slug), CONSTRAINT fk_country_currency FOREIGN KEY(currency_code) REFERENCES currencies(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE cities (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, country_id BIGINT UNSIGNED NOT NULL, slug VARCHAR(150) NOT NULL, name VARCHAR(160) NOT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_city_slug(country_id,slug), CONSTRAINT fk_city_country FOREIGN KEY(country_id) REFERENCES countries(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE treatments (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, slug VARCHAR(150) NOT NULL, category VARCHAR(100) NOT NULL, name VARCHAR(255) NOT NULL, overview TEXT NOT NULL, risk_notes TEXT NOT NULL, aftercare_notes TEXT NOT NULL, medical_review_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending', status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_treatment_slug(slug)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE offerings (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, city_id BIGINT UNSIGNED NOT NULL, treatment_id BIGINT UNSIGNED NOT NULL, slug VARCHAR(150) NOT NULL, evidence_status ENUM('unverified','partially_verified','verified') NOT NULL DEFAULT 'unverified', status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY uq_offering_city_treatment(city_id,treatment_id), KEY idx_offering_treatment(treatment_id), CONSTRAINT fk_offering_city FOREIGN KEY(city_id) REFERENCES cities(id), CONSTRAINT fk_offering_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE translations (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, entity_type VARCHAR(40) NOT NULL, entity_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, title VARCHAR(500) NULL, h1 VARCHAR(500) NULL, meta_description VARCHAR(1000) NULL, summary TEXT NULL, body LONGTEXT NULL, human_reviewed TINYINT(1) NOT NULL DEFAULT 0, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_translation(entity_type,entity_id,lang), CONSTRAINT fk_translation_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE treatment_profiles (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, treatment_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, body LONGTEXT NOT NULL, medical_review_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending', status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_profile(treatment_id,lang), CONSTRAINT fk_profile_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id), CONSTRAINT fk_profile_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE treatment_faqs (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, treatment_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, position INT UNSIGNED NOT NULL, question TEXT NOT NULL, answer TEXT NOT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_tfaq(treatment_id,lang,position), CONSTRAINT fk_tfaq_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id), CONSTRAINT fk_tfaq_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE faqs (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, offering_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL DEFAULT 'en', position INT UNSIGNED NOT NULL, question TEXT NOT NULL, answer TEXT NOT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', UNIQUE KEY uq_ofaq(offering_id,lang,position), CONSTRAINT fk_faq_offering FOREIGN KEY(offering_id) REFERENCES offerings(id), CONSTRAINT fk_faq_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE research_references (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, source_type VARCHAR(50) NOT NULL, organization VARCHAR(255) NOT NULL, title VARCHAR(500) NOT NULL, source_url VARCHAR(1000) NOT NULL, country_code CHAR(2) NULL, evidence_scope VARCHAR(100) NOT NULL, checked_on DATE NULL, verification_status ENUM('pending','verified','rejected') NOT NULL DEFAULT 'pending', KEY idx_ref_country(country_code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE clinics (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, city_id BIGINT UNSIGNED NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(150) NOT NULL, website_url VARCHAR(1000) NULL, identity_status ENUM('unverified','verified') NOT NULL DEFAULT 'unverified', authorization_status ENUM('unverified','verified','not_applicable') NOT NULL DEFAULT 'unverified', status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', UNIQUE KEY uq_clinic(city_id,slug), CONSTRAINT fk_clinic_city FOREIGN KEY(city_id) REFERENCES cities(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE doctors (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, city_id BIGINT UNSIGNED NOT NULL, name VARCHAR(255) NOT NULL, specialty VARCHAR(255) NULL, registry_url VARCHAR(1000) NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', CONSTRAINT fk_doctor_city FOREIGN KEY(city_id) REFERENCES cities(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE clinic_treatments (clinic_id BIGINT UNSIGNED NOT NULL, treatment_id BIGINT UNSIGNED NOT NULL, source_id BIGINT UNSIGNED NULL, verification_status ENUM('unverified','verified') NOT NULL DEFAULT 'unverified', PRIMARY KEY(clinic_id,treatment_id), CONSTRAINT fk_ct_clinic FOREIGN KEY(clinic_id) REFERENCES clinics(id), CONSTRAINT fk_ct_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id), CONSTRAINT fk_ct_source FOREIGN KEY(source_id) REFERENCES research_references(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE clinic_doctors (clinic_id BIGINT UNSIGNED NOT NULL, doctor_id BIGINT UNSIGNED NOT NULL, verification_status ENUM('unverified','verified') NOT NULL DEFAULT 'unverified', PRIMARY KEY(clinic_id,doctor_id), CONSTRAINT fk_cd_clinic FOREIGN KEY(clinic_id) REFERENCES clinics(id), CONSTRAINT fk_cd_doctor FOREIGN KEY(doctor_id) REFERENCES doctors(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE facility_verifications (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, clinic_id BIGINT UNSIGNED NOT NULL, source_id BIGINT UNSIGNED NOT NULL, evidence_scope VARCHAR(150) NOT NULL, checked_on DATE NULL, status ENUM('pending','verified','rejected') NOT NULL DEFAULT 'pending', CONSTRAINT fk_fv_clinic FOREIGN KEY(clinic_id) REFERENCES clinics(id), CONSTRAINT fk_fv_source FOREIGN KEY(source_id) REFERENCES research_references(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE doctor_verifications (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, doctor_id BIGINT UNSIGNED NOT NULL, source_id BIGINT UNSIGNED NOT NULL, evidence_scope VARCHAR(150) NOT NULL, checked_on DATE NULL, status ENUM('pending','verified','rejected') NOT NULL DEFAULT 'pending', CONSTRAINT fk_dv_doctor FOREIGN KEY(doctor_id) REFERENCES doctors(id), CONSTRAINT fk_dv_source FOREIGN KEY(source_id) REFERENCES research_references(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE prices (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, clinic_id BIGINT UNSIGNED NOT NULL, treatment_id BIGINT UNSIGNED NOT NULL, currency_code CHAR(3) NOT NULL, amount_min DECIMAL(12,2) NULL, amount_max DECIMAL(12,2) NULL, price_status ENUM('quote_required','verified','expired') NOT NULL DEFAULT 'quote_required', source_id BIGINT UNSIGNED NULL, quoted_on DATE NULL, expires_on DATE NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review', CONSTRAINT fk_price_clinic FOREIGN KEY(clinic_id) REFERENCES clinics(id), CONSTRAINT fk_price_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id), CONSTRAINT fk_price_currency FOREIGN KEY(currency_code) REFERENCES currencies(code), CONSTRAINT fk_price_source FOREIGN KEY(source_id) REFERENCES research_references(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE price_benchmarks (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, country_id BIGINT UNSIGNED NOT NULL, treatment_id BIGINT UNSIGNED NOT NULL, currency_code CHAR(3) NOT NULL, amount_min DECIMAL(12,2) NULL, amount_max DECIMAL(12,2) NULL, source_id BIGINT UNSIGNED NULL, confidence ENUM('low','medium','high') NOT NULL DEFAULT 'low', publishable TINYINT(1) NOT NULL DEFAULT 0, CONSTRAINT fk_pb_country FOREIGN KEY(country_id) REFERENCES countries(id), CONSTRAINT fk_pb_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id), CONSTRAINT fk_pb_currency FOREIGN KEY(currency_code) REFERENCES currencies(code), CONSTRAINT fk_pb_source FOREIGN KEY(source_id) REFERENCES research_references(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE seo_records (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, entity_type VARCHAR(40) NOT NULL, entity_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, title VARCHAR(500) NULL, h1 VARCHAR(500) NULL, meta_description VARCHAR(1000) NULL, canonical_path VARCHAR(700) NOT NULL, robots_policy ENUM('noindex','index') NOT NULL DEFAULT 'noindex', status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', UNIQUE KEY uq_seo_entity_lang(entity_type,entity_id,lang), KEY idx_seo_path(canonical_path(160)), CONSTRAINT fk_seo_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE seo_alternates (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, entity_type VARCHAR(40) NOT NULL, entity_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, alternate_lang VARCHAR(12) NOT NULL, alternate_path VARCHAR(700) NOT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', UNIQUE KEY uq_alternate(entity_type,entity_id,lang,alternate_lang), CONSTRAINT fk_alt_lang FOREIGN KEY(lang) REFERENCES languages(code), CONSTRAINT fk_alt_target_lang FOREIGN KEY(alternate_lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE structured_data (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, entity_type VARCHAR(40) NOT NULL, entity_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, schema_type VARCHAR(100) NOT NULL, json_ld LONGTEXT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', UNIQUE KEY uq_schema(entity_type,entity_id,lang,schema_type), CONSTRAINT fk_structured_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE media_assets (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, file_url VARCHAR(1000) NOT NULL, license_type VARCHAR(100) NULL, attribution VARCHAR(500) NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'review') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE image_metadata (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, entity_type VARCHAR(40) NOT NULL, entity_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, planned_filename VARCHAR(255) NOT NULL, alt_text VARCHAR(500) NULL, asset_id BIGINT UNSIGNED NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', UNIQUE KEY uq_image(entity_type,entity_id,lang), CONSTRAINT fk_img_lang FOREIGN KEY(lang) REFERENCES languages(code), CONSTRAINT fk_img_asset FOREIGN KEY(asset_id) REFERENCES media_assets(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE blogs (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, city_id BIGINT UNSIGNED NULL, slug VARCHAR(150) NOT NULL, title VARCHAR(500) NOT NULL, summary TEXT NULL, body LONGTEXT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', published_at DATETIME NULL, UNIQUE KEY uq_blog_slug(slug), CONSTRAINT fk_blog_city FOREIGN KEY(city_id) REFERENCES cities(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE blog_translations (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, blog_id BIGINT UNSIGNED NOT NULL, lang VARCHAR(12) NOT NULL, title VARCHAR(500) NULL, body LONGTEXT NULL, human_reviewed TINYINT(1) NOT NULL DEFAULT 0, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', UNIQUE KEY uq_blog_lang(blog_id,lang), CONSTRAINT fk_bt_blog FOREIGN KEY(blog_id) REFERENCES blogs(id), CONSTRAINT fk_bt_lang FOREIGN KEY(lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE editorial_todos (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, entity_type VARCHAR(40) NOT NULL, entity_id BIGINT UNSIGNED NOT NULL, task_code VARCHAR(80) NOT NULL, details TEXT NULL, priority ENUM('low','normal','high','critical') NOT NULL DEFAULT 'normal', status ENUM('open','in_progress','done','blocked') NOT NULL DEFAULT 'open', UNIQUE KEY uq_task(entity_type,entity_id,task_code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE packages (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, city_id BIGINT UNSIGNED NOT NULL, name VARCHAR(255) NOT NULL, description TEXT NULL, status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft', CONSTRAINT fk_package_city FOREIGN KEY(city_id) REFERENCES cities(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE package_items (package_id BIGINT UNSIGNED NOT NULL, treatment_id BIGINT UNSIGNED NOT NULL, PRIMARY KEY(package_id,treatment_id), CONSTRAINT fk_pi_package FOREIGN KEY(package_id) REFERENCES packages(id), CONSTRAINT fk_pi_treatment FOREIGN KEY(treatment_id) REFERENCES treatments(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE bookings (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, package_id BIGINT UNSIGNED NULL, customer_email VARCHAR(255) NOT NULL, status ENUM('new','contacted','confirmed','cancelled') NOT NULL DEFAULT 'new', created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_booking_package FOREIGN KEY(package_id) REFERENCES packages(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE contact_inquiries (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(255) NULL, email VARCHAR(255) NOT NULL, message TEXT NOT NULL, status ENUM('new','contacted','closed') NOT NULL DEFAULT 'new', created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE consultation_requests (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, offering_id BIGINT UNSIGNED NULL, clinic_id BIGINT UNSIGNED NULL, email VARCHAR(255) NOT NULL, preferred_lang VARCHAR(12) NULL, details TEXT NULL, status ENUM('new','contacted','closed') NOT NULL DEFAULT 'new', created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_cr_offering FOREIGN KEY(offering_id) REFERENCES offerings(id), CONSTRAINT fk_cr_clinic FOREIGN KEY(clinic_id) REFERENCES clinics(id), CONSTRAINT fk_cr_lang FOREIGN KEY(preferred_lang) REFERENCES languages(code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE admins (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, email VARCHAR(255) NOT NULL, password_hash VARCHAR(255) NOT NULL, is_active TINYINT(1) NOT NULL DEFAULT 0, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY uq_admin_email(email)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

CREATE TABLE audit_logs (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, admin_id BIGINT UNSIGNED NULL, action VARCHAR(255) NOT NULL, payload LONGTEXT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_audit_admin FOREIGN KEY(admin_id) REFERENCES admins(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;;

-- SEED: languages, currencies, countries, cities, treatments

INSERT INTO languages (code,name,native_name,is_rtl,enabled) VALUES
('en','English','English',0,1),
('fa','Persian','فارسی',1,0),
('tr','Turkish','Türkçe',0,0),
('ar','Arabic','العربية',1,0),
('de','German','Deutsch',0,0),
('fr','French','Français',0,0),
('es','Spanish','Español',0,0),
('it','Italian','Italiano',0,0),
('pt','Portuguese','Português',0,0),
('ru','Russian','Русский',0,0),
('zh','Chinese','中文',0,0),
('ja','Japanese','日本語',0,0),
('ko','Korean','한국어',0,0),
('hi','Hindi','हिन्दी',0,0),
('th','Thai','ไทย',0,0),
('id','Indonesian','Bahasa Indonesia',0,0),
('vi','Vietnamese','Tiếng Việt',0,0),
('he','Hebrew','עברית',1,0),
('el','Greek','Ελληνικά',0,0),
('cs','Czech','Čeština',0,0),
('hu','Hungarian','Magyar',0,0),
('pl','Polish','Polski',0,0),
('nl','Dutch','Nederlands',0,0),
('sv','Swedish','Svenska',0,0),
('no','Norwegian','Norsk',0,0),
('da','Danish','Dansk',0,0),
('fi','Finnish','Suomi',0,0),
('ur','Urdu','اردو',1,0),
('az','Azerbaijani','Azərbaycanca',0,0),
('kk','Kazakh','Қазақша',0,0),
('uz','Uzbek','Oʻzbekcha',0,0),
('ro','Romanian','Română',0,0);

INSERT INTO currencies (code,name,symbol) VALUES
('USD','US Dollar','$'),
('EUR','Euro','€'),
('TRY','Turkish Lira','₺'),
('IRR','Iranian Rial','﷼'),
('THB','Thai Baht','฿'),
('INR','Indian Rupee','₹'),
('MXN','Mexican Peso','$'),
('KRW','South Korean Won','₩'),
('MYR','Malaysian Ringgit','RM'),
('SGD','Singapore Dollar','S$'),
('AED','UAE Dirham','د.إ'),
('HUF','Hungarian Forint','Ft'),
('PLN','Polish Zloty','zł'),
('CZK','Czech Koruna','Kč'),
('BRL','Brazilian Real','R$'),
('COP','Colombian Peso','$'),
('CRC','Costa Rican Colon','₡'),
('DOP','Dominican Peso','RD$'),
('JOD','Jordanian Dinar','JD'),
('ILS','Israeli New Shekel','₪'),
('TWD','New Taiwan Dollar','NT$'),
('JPY','Japanese Yen','¥'),
('VND','Vietnamese Dong','₫'),
('IDR','Indonesian Rupiah','Rp'),
('EGP','Egyptian Pound','E£'),
('TND','Tunisian Dinar','DT');

INSERT INTO countries (code,slug,name,currency_code) VALUES
('TR','turkey','Turkey','TRY'),
('IR','iran','Iran','IRR'),
('TH','thailand','Thailand','THB'),
('IN','india','India','INR'),
('MX','mexico','Mexico','MXN'),
('KR','south-korea','South Korea','KRW'),
('MY','malaysia','Malaysia','MYR'),
('SG','singapore','Singapore','SGD'),
('AE','united-arab-emirates','United Arab Emirates','AED'),
('HU','hungary','Hungary','HUF'),
('PL','poland','Poland','PLN'),
('CZ','czech-republic','Czech Republic','CZK'),
('ES','spain','Spain','EUR'),
('DE','germany','Germany','EUR'),
('BR','brazil','Brazil','BRL'),
('CO','colombia','Colombia','COP'),
('CR','costa-rica','Costa Rica','CRC'),
('DO','dominican-republic','Dominican Republic','DOP'),
('JO','jordan','Jordan','JOD'),
('IL','israel','Israel','ILS'),
('TW','taiwan','Taiwan','TWD'),
('JP','japan','Japan','JPY'),
('VN','vietnam','Vietnam','VND'),
('ID','indonesia','Indonesia','IDR'),
('EG','egypt','Egypt','EGP'),
('TN','tunisia','Tunisia','TND');

INSERT INTO cities (country_id,slug,name) VALUES
((SELECT id FROM countries WHERE code='TR'),'istanbul','Istanbul'),
((SELECT id FROM countries WHERE code='TR'),'ankara','Ankara'),
((SELECT id FROM countries WHERE code='TR'),'izmir','Izmir'),
((SELECT id FROM countries WHERE code='TR'),'antalya','Antalya'),
((SELECT id FROM countries WHERE code='TR'),'bursa','Bursa'),
((SELECT id FROM countries WHERE code='TR'),'konya','Konya'),
((SELECT id FROM countries WHERE code='TR'),'gaziantep','Gaziantep'),
((SELECT id FROM countries WHERE code='TR'),'adana','Adana'),
((SELECT id FROM countries WHERE code='TR'),'kayseri','Kayseri'),
((SELECT id FROM countries WHERE code='TR'),'mersin','Mersin'),
((SELECT id FROM countries WHERE code='TR'),'kocaeli','Kocaeli'),
((SELECT id FROM countries WHERE code='TR'),'eskisehir','Eskisehir'),
((SELECT id FROM countries WHERE code='TR'),'trabzon','Trabzon'),
((SELECT id FROM countries WHERE code='TR'),'samsun','Samsun'),
((SELECT id FROM countries WHERE code='TR'),'mugla','Mugla'),
((SELECT id FROM countries WHERE code='TR'),'bodrum','Bodrum'),
((SELECT id FROM countries WHERE code='TR'),'fethiye','Fethiye'),
((SELECT id FROM countries WHERE code='TR'),'marmaris','Marmaris'),
((SELECT id FROM countries WHERE code='TR'),'denizli','Denizli'),
((SELECT id FROM countries WHERE code='TR'),'aydin','Aydin'),
((SELECT id FROM countries WHERE code='TR'),'kusadasi','Kusadasi'),
((SELECT id FROM countries WHERE code='TR'),'sakarya','Sakarya'),
((SELECT id FROM countries WHERE code='TR'),'yalova','Yalova'),
((SELECT id FROM countries WHERE code='TR'),'canakkale','Canakkale'),
((SELECT id FROM countries WHERE code='TR'),'balikesir','Balikesir'),
((SELECT id FROM countries WHERE code='TR'),'hatay','Hatay'),
((SELECT id FROM countries WHERE code='TR'),'sanliurfa','Sanliurfa'),
((SELECT id FROM countries WHERE code='TR'),'diyarbakir','Diyarbakir'),
((SELECT id FROM countries WHERE code='TR'),'alanya','Alanya'),
((SELECT id FROM countries WHERE code='TR'),'manavgat','Manavgat'),
((SELECT id FROM countries WHERE code='IR'),'tehran','Tehran'),
((SELECT id FROM countries WHERE code='IR'),'mashhad','Mashhad'),
((SELECT id FROM countries WHERE code='IR'),'isfahan','Isfahan'),
((SELECT id FROM countries WHERE code='IR'),'shiraz','Shiraz'),
((SELECT id FROM countries WHERE code='IR'),'tabriz','Tabriz'),
((SELECT id FROM countries WHERE code='IR'),'karaj','Karaj'),
((SELECT id FROM countries WHERE code='IR'),'qom','Qom'),
((SELECT id FROM countries WHERE code='IR'),'ahvaz','Ahvaz'),
((SELECT id FROM countries WHERE code='IR'),'kermanshah','Kermanshah'),
((SELECT id FROM countries WHERE code='IR'),'rasht','Rasht'),
((SELECT id FROM countries WHERE code='IR'),'yazd','Yazd'),
((SELECT id FROM countries WHERE code='IR'),'kerman','Kerman'),
((SELECT id FROM countries WHERE code='IR'),'kish','Kish'),
((SELECT id FROM countries WHERE code='IR'),'hamedan','Hamedan'),
((SELECT id FROM countries WHERE code='IR'),'urmia','Urmia'),
((SELECT id FROM countries WHERE code='TH'),'bangkok','Bangkok'),
((SELECT id FROM countries WHERE code='IN'),'new-delhi','New Delhi'),
((SELECT id FROM countries WHERE code='MX'),'mexico-city','Mexico City'),
((SELECT id FROM countries WHERE code='KR'),'seoul','Seoul'),
((SELECT id FROM countries WHERE code='MY'),'kuala-lumpur','Kuala Lumpur'),
((SELECT id FROM countries WHERE code='SG'),'singapore','Singapore'),
((SELECT id FROM countries WHERE code='AE'),'dubai','Dubai'),
((SELECT id FROM countries WHERE code='HU'),'budapest','Budapest'),
((SELECT id FROM countries WHERE code='PL'),'warsaw','Warsaw'),
((SELECT id FROM countries WHERE code='CZ'),'prague','Prague'),
((SELECT id FROM countries WHERE code='ES'),'barcelona','Barcelona'),
((SELECT id FROM countries WHERE code='DE'),'berlin','Berlin'),
((SELECT id FROM countries WHERE code='BR'),'sao-paulo','Sao Paulo'),
((SELECT id FROM countries WHERE code='CO'),'bogota','Bogota'),
((SELECT id FROM countries WHERE code='CR'),'san-jose','San Jose'),
((SELECT id FROM countries WHERE code='DO'),'santo-domingo','Santo Domingo'),
((SELECT id FROM countries WHERE code='JO'),'amman','Amman'),
((SELECT id FROM countries WHERE code='IL'),'tel-aviv','Tel Aviv'),
((SELECT id FROM countries WHERE code='TW'),'taipei','Taipei'),
((SELECT id FROM countries WHERE code='JP'),'tokyo','Tokyo'),
((SELECT id FROM countries WHERE code='VN'),'ho-chi-minh-city','Ho Chi Minh City'),
((SELECT id FROM countries WHERE code='ID'),'jakarta','Jakarta'),
((SELECT id FROM countries WHERE code='EG'),'cairo','Cairo'),
((SELECT id FROM countries WHERE code='TN'),'tunis','Tunis');

INSERT INTO treatments (slug,category,name,overview,risk_notes,aftercare_notes) VALUES
('dental-implants','dental','Dental Implants','Dental implants are surgically placed supports for replacement teeth. Evaluation of bone, gums and medical history is needed.','Infection, implant failure, nerve injury and other surgical complications are possible.','Treatment may require several visits; follow the dental team''s review and hygiene plan.'),
('all-on-4','dental','Full-Arch Implant Rehabilitation','Full-arch implant treatment may use strategically placed implants to support a fixed prosthesis. Suitability depends on individual anatomy.','Infection, implant failure, prosthetic problems and further surgery are possible.','Temporary and final restorations can follow different schedules; long-term maintenance is essential.'),
('dental-veneers','dental','Dental Veneers','Veneers are thin restorations used to change tooth appearance. Planning should consider bite, enamel and oral health.','Sensitivity, fracture, debonding and irreversible enamel removal may occur.','Maintain oral hygiene and avoid habits that could damage restorations.'),
('dental-crowns','dental','Dental Crowns','Crowns restore or cover teeth. Material choice and preparation depend on examination and clinical needs.','Sensitivity, recurrent decay, gum irritation and crown failure can occur.','Follow-up examinations and regular oral hygiene are important.'),
('teeth-whitening','dental','Teeth Whitening','Tooth whitening may improve some types of discoloration. A dental examination should identify causes of staining.','Temporary sensitivity and gum irritation may occur.','Follow the dentist''s instructions; avoid excessive repeat whitening.'),
('orthodontics','dental','Orthodontic Treatment','Orthodontic treatment may use braces or aligners to address tooth alignment and bite problems.','Discomfort, enamel damage, root changes and gum problems may occur.','Regular visits, good hygiene and prescribed retainer use are important.'),
('hair-transplant','aesthetic','Hair Transplantation','Hair transplantation relocates follicles from a donor area. Diagnosis of hair loss and donor assessment are essential.','Infection, scarring, poor graft survival and an unsatisfactory appearance are possible.','Protect grafts according to the treating team''s instructions; results develop gradually.'),
('rhinoplasty','aesthetic','Rhinoplasty','Rhinoplasty changes nasal shape and sometimes addresses functional concerns. Airway assessment and realistic expectations matter.','Bleeding, infection, breathing difficulties, asymmetry and revision surgery may occur.','Swelling and follow-up can continue for months.'),
('blepharoplasty','aesthetic','Blepharoplasty','Eyelid surgery removes or repositions selected eyelid tissues for cosmetic or functional reasons.','Dry eyes, asymmetry, scarring, bleeding and rare vision-threatening complications are possible.','Follow eye-care instructions and promptly report significant visual symptoms.'),
('liposuction','aesthetic','Liposuction','Liposuction removes localized fat deposits and is not a treatment for obesity.','Contour irregularities, infection, thrombosis, fluid imbalance and anesthesia complications may occur.','Compression, mobilization and follow-up depend on the procedure and personal risk.'),
('breast-augmentation','aesthetic','Breast Augmentation','Breast augmentation may use implants or other approaches to change breast size and shape.','Infection, capsular contracture, implant complications, sensation changes and further surgery are possible.','Discuss long-term follow-up and implant surveillance before surgery.'),
('abdominoplasty','aesthetic','Abdominoplasty','Abdominoplasty removes selected excess abdominal skin and may address abdominal wall separation.','Wound problems, thrombosis, infection, fluid collections and scarring may occur.','Recovery restrictions and postoperative support must be planned before travel.'),
('lasik','ophthalmology','LASIK and Refractive Surgery','Refractive surgery aims to reduce dependence on glasses or contact lenses; eligibility requires a detailed eye examination.','Dry eye, glare, undercorrection, overcorrection and rare serious complications are possible.','Attend postoperative eye examinations and follow activity restrictions.'),
('cataract-surgery','ophthalmology','Cataract Surgery','Cataract surgery removes a cloudy natural lens and usually replaces it with an intraocular lens.','Infection, inflammation, retinal problems and other visual complications may occur.','Use prescribed drops and attend postoperative examinations.'),
('ivf','fertility','In Vitro Fertilization','IVF may involve ovarian stimulation, egg retrieval, laboratory fertilization and embryo transfer when clinically appropriate.','Ovarian hyperstimulation, procedural complications, multiple pregnancy and emotional burden are possible.','Plan monitoring, medication access and continuity of fertility care before travel.'),
('knee-replacement','orthopedics','Knee Replacement','Knee replacement may be considered for severe joint disease after appropriate assessment and discussion of alternatives.','Infection, thrombosis, stiffness, implant problems and anesthesia complications may occur.','Rehabilitation and thrombosis prevention are particularly important before long-distance travel.'),
('hip-replacement','orthopedics','Hip Replacement','Hip replacement substitutes damaged joint surfaces in appropriately selected patients.','Infection, dislocation, thrombosis, fracture and implant complications may occur.','Arrange rehabilitation, wound care and follow-up after returning home.'),
('bariatric-surgery','bariatric','Bariatric Surgery','Bariatric surgery changes the digestive system to support weight management in selected patients.','Leaks, bleeding, nutritional deficiencies, thrombosis and reoperation may occur.','Long-term nutrition monitoring, supplements and multidisciplinary care are essential.'),
('health-checkup','preventive','Preventive Health Check-up','Evidence-based preventive care depends on age, risk factors and medical history, not a universal test package.','Unnecessary screening may cause false positives, anxiety and avoidable procedures.','Review results with a qualified clinician and arrange follow-up of abnormal findings.'),
('dermatology','dermatology','Dermatology','Dermatology covers assessment and treatment of skin, hair and nail conditions; treatment depends on diagnosis.','Risks vary by medication and procedure and may include irritation, scarring, infection or adverse reactions.','Follow the individual treatment plan and seek review for unexpected symptoms.');

-- City-treatment records are UNVERIFIED CANDIDATES, not claims of available care.
INSERT INTO offerings(city_id,treatment_id,slug,status,evidence_status)
SELECT ci.id,t.id,t.slug,'draft','unverified' FROM cities ci CROSS JOIN treatments t;

-- English draft translations; no fabricated fa/tr/other language content.
INSERT INTO translations(entity_type,entity_id,lang,title,h1,meta_description,summary,status)
SELECT 'treatment',id,'en',name,name,CONCAT('Evidence-aware information about ',name,', risks, travel planning and follow-up.'),overview,'review' FROM treatments;
INSERT INTO translations(entity_type,entity_id,lang,title,h1,meta_description,summary,status)
SELECT 'country',id,'en',name,CONCAT('Medical Travel in ',name),CONCAT('Explore medical travel planning for ',name,'.'),CONCAT('Destination overview for ',name,'; provider availability requires verification.'),'review' FROM countries;
INSERT INTO translations(entity_type,entity_id,lang,title,h1,meta_description,summary,status)
SELECT 'city',ci.id,'en',CONCAT(ci.name,', ',co.name),CONCAT('Medical Travel in ',ci.name),CONCAT('Medical travel planning in ',ci.name,', ',co.name,'.'),CONCAT('Information about ',ci.name,'; no treatment availability is confirmed.'),'review'
FROM cities ci JOIN countries co ON co.id=ci.country_id;

INSERT INTO treatment_profiles(treatment_id,lang,body,medical_review_status,status)
SELECT id,'en',CONCAT('OVERVIEW\n',overview,'\n\nRISKS AND LIMITATIONS\n',risk_notes,'\n\nAFTERCARE\n',aftercare_notes,'\n\nBEFORE TRAVEL\nA qualified treating clinician must assess eligibility and contraindications. Obtain a written care plan, procedure-specific risks, a verified provider identity, a detailed quote and an emergency plan. Arrange follow-up at home. This text is a draft and requires clinical review.'),'pending','review'
FROM treatments;

CREATE TEMPORARY TABLE tmp_faq_templates (position INT UNSIGNED NOT NULL PRIMARY KEY, question VARCHAR(300) NOT NULL, answer_template TEXT NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_faq_templates (position,question,answer_template) VALUES
(1,'What is this procedure?','overview'),
(2,'Who may be suitable?','A qualified clinician should assess individual medical history, examination findings, goals and contraindications.'),
(3,'What assessment is required before treatment?','Review medications, allergies, relevant tests and any condition-specific evaluation with the treating team.'),
(4,'What are the possible risks?','risk'),
(5,'What does recovery involve?','aftercare'),
(6,'How long should I remain near the treating provider?','Stay length depends on the procedure, recovery and follow-up requirements; obtain a personalized schedule before booking flights.'),
(7,'How can I confirm the cost?','Request a dated written quotation directly from the provider that specifies inclusions, exclusions and possible extra charges.'),
(8,'What if complications occur?','Confirm emergency contacts, transfer arrangements, complication management and access to clinical records.'),
(9,'How can I verify a provider?','Check the facility identity, current authorizations, clinician credentials, procedure availability and follow-up arrangements.'),
(10,'What follow-up is required after returning home?','Arrange records transfer and follow-up with a qualified local clinician before travelling.');

INSERT INTO treatment_faqs(treatment_id,lang,position,question,answer,status)
SELECT t.id,'en',f.position,f.question,
CASE f.answer_template WHEN 'overview' THEN t.overview WHEN 'risk' THEN t.risk_notes WHEN 'aftercare' THEN t.aftercare_notes ELSE f.answer_template END,
'review'
FROM treatments t CROSS JOIN tmp_faq_templates f;
DROP TEMPORARY TABLE tmp_faq_templates;
-- These 10 offering FAQs are duplicated draft templates, never publish as unique city answers.
INSERT INTO faqs(offering_id,lang,position,question,answer,status)
SELECT o.id,'en',f.position,f.question,f.answer,'draft'
FROM offerings o JOIN treatment_faqs f ON f.treatment_id=o.treatment_id AND f.lang='en';

INSERT INTO research_references (source_type,organization,title,source_url,country_code,evidence_scope) VALUES
('regulator','Turkish Ministry of Health','International Health Tourism','https://shgm.saglik.gov.tr/','TR','regulatory_overview'),
('regulator','Iran Ministry of Health','Ministry of Health and Medical Education','https://behdasht.gov.ir/','IR','regulatory_overview'),
('registry','Iran Medical Council','Physician Registry','https://membersearch.irimc.org/','IR','professional_registry'),
('hospital','Turkish Ministry of Health','Basaksehir Cam and Sakura City Hospital','https://camsakurasehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Ankara Bilkent City Hospital','https://ankarasehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Izmir City Hospital','https://izmirsehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Antalya Training and Research Hospital','https://antalyaeah.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Bursa City Hospital','https://bursasehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Konya City Hospital','https://konyasehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Gaziantep City Hospital','https://gaziantepsehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Adana City Hospital','https://adanasehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Kayseri City Hospital','https://kayserisehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Turkish Ministry of Health','Mersin City Hospital','https://mersinsehir.saglik.gov.tr/','TR','institutional_identity'),
('hospital','Tehran University of Medical Sciences','Shariati Hospital','https://shariati.tums.ac.ir/','IR','institutional_identity'),
('hospital','Isfahan University of Medical Sciences','Alzahra Hospital','https://alzahra.mui.ac.ir/','IR','institutional_identity'),
('hospital','Bumrungrad International Hospital','Official Website','https://www.bumrungrad.com/','TH','institutional_identity'),
('university','Semmelweis University','Clinical Center','https://semmelweis.hu/klinikaikozpont/','HU','institutional_identity'),
('clinical','American Dental Association','Oral Health Topics','https://www.ada.org/resources/ada-library/oral-health-topics',NULL,'clinical_background'),
('clinical','American Society of Plastic Surgeons','Patient Safety','https://www.plasticsurgery.org/patient-safety',NULL,'clinical_background'),
('clinical','NIDDK','Weight Management and Bariatric Surgery','https://www.niddk.nih.gov/health-information/weight-management/bariatric-surgery',NULL,'clinical_background'),
('clinical','USPSTF','Recommendations','https://www.uspreventiveservicestaskforce.org/uspstf/recommendation-topics',NULL,'clinical_background'),
('seo','Google Search Central','Creating Helpful Reliable People-First Content','https://developers.google.com/search/docs/fundamentals/creating-helpful-content',NULL,'seo_policy'),
('seo','Google Search Central','Localized Versions of Pages','https://developers.google.com/search/docs/specialty/international/localized-versions',NULL,'international_seo'),
('seo','Google Search Central','Consolidate Duplicate URLs','https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls',NULL,'canonical_policy'),
('seo','Google Search Central','Structured Data Guidelines','https://developers.google.com/search/docs/appearance/structured-data/sd-policies',NULL,'structured_data_policy');

-- Hospital names and URLs are RESEARCH LEADS, not verified clinic partners.
INSERT INTO clinics(city_id,name,slug,website_url,identity_status,authorization_status,status) VALUES
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='istanbul'),'Basaksehir Cam and Sakura City Hospital','basaksehir-cam-sakura','https://camsakurasehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='ankara'),'Ankara Bilkent City Hospital','ankara-bilkent-city','https://ankarasehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='izmir'),'Izmir City Hospital','izmir-city','https://izmirsehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='antalya'),'Antalya Training and Research Hospital','antalya-training-research','https://antalyaeah.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='bursa'),'Bursa City Hospital','bursa-city','https://bursasehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='konya'),'Konya City Hospital','konya-city','https://konyasehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='gaziantep'),'Gaziantep City Hospital','gaziantep-city','https://gaziantepsehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='adana'),'Adana City Hospital','adana-city','https://adanasehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='kayseri'),'Kayseri City Hospital','kayseri-city','https://kayserisehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TR' AND ci.slug='mersin'),'Mersin City Hospital','mersin-city','https://mersinsehir.saglik.gov.tr/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='IR' AND ci.slug='tehran'),'Shariati Hospital','shariati-hospital','https://shariati.tums.ac.ir/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='IR' AND ci.slug='isfahan'),'Alzahra Hospital','alzahra-hospital','https://alzahra.mui.ac.ir/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='TH' AND ci.slug='bangkok'),'Bumrungrad International Hospital','bumrungrad-international','https://www.bumrungrad.com/','unverified','unverified','review'),
((SELECT ci.id FROM cities ci JOIN countries co ON co.id=ci.country_id WHERE co.code='HU' AND ci.slug='budapest'),'Semmelweis University Clinical Center','semmelweis-clinical-center','https://semmelweis.hu/klinikaikozpont/','unverified','unverified','review');

INSERT INTO facility_verifications(clinic_id,source_id,evidence_scope,status)
SELECT cl.id,rr.id,'institutional_identity_only','pending'
FROM clinics cl JOIN research_references rr ON rr.source_url=cl.website_url AND rr.evidence_scope='institutional_identity';

-- Canonical URLs are planned only; noindex/draft until unique content and clinical review.
INSERT INTO seo_records(entity_type,entity_id,lang,title,h1,meta_description,canonical_path,robots_policy,status)
SELECT 'treatment',id,'en',name,name,CONCAT('Information about ',name,', risks and care planning.'),CONCAT('/en/treatments/',slug),'noindex','draft' FROM treatments;
INSERT INTO seo_records(entity_type,entity_id,lang,title,h1,meta_description,canonical_path,robots_policy,status)
SELECT 'country',id,'en',CONCAT('Medical Travel in ',name),CONCAT('Medical Travel in ',name),CONCAT('Destination planning for ',name,'.'),CONCAT('/en/',slug),'noindex','draft' FROM countries;
INSERT INTO seo_records(entity_type,entity_id,lang,title,h1,meta_description,canonical_path,robots_policy,status)
SELECT 'city',ci.id,'en',CONCAT('Medical Travel in ',ci.name),CONCAT('Medical Travel in ',ci.name),CONCAT('Destination planning for ',ci.name,', ',co.name,'.'),CONCAT('/en/',co.slug,'/',ci.slug),'noindex','draft'
FROM cities ci JOIN countries co ON co.id=ci.country_id;
INSERT INTO seo_records(entity_type,entity_id,lang,title,h1,meta_description,canonical_path,robots_policy,status)
SELECT 'offering',o.id,'en',CONCAT(t.name,' in ',ci.name),CONCAT(t.name,' in ',ci.name),CONCAT('Research and planning for ',t.name,' in ',ci.name,'. Availability is not confirmed.'),CONCAT('/en/',co.slug,'/',ci.slug,'/',t.slug),'noindex','draft'
FROM offerings o JOIN treatments t ON t.id=o.treatment_id JOIN cities ci ON ci.id=o.city_id JOIN countries co ON co.id=ci.country_id;

-- No hreflang alternates: localized translated pages have not been produced.
-- No JSON-LD for unverified facilities or FAQs.
-- No image assets, real prices or doctor identities are invented.
INSERT INTO image_metadata(entity_type,entity_id,lang,planned_filename,alt_text,status)
SELECT 'treatment',id,'en',CONCAT(slug,'.webp'),CONCAT('Licensed medical image for ',name),'draft' FROM treatments;
INSERT INTO blogs(city_id,slug,title,summary,body,status)
SELECT ci.id,CONCAT('medical-travel-guide-',co.slug,'-',ci.slug),CONCAT('Medical Travel Guide: ',ci.name,', ',co.name),
CONCAT('Research outline for medical travel to ',ci.name,'.'),
'Editorial placeholder only. Research visa rules, hospital authorization, local transport, emergency care, recovery logistics, follow-up and current payment restrictions before writing a unique article.','draft'
FROM cities ci JOIN countries co ON co.id=ci.country_id;
INSERT INTO editorial_todos(entity_type,entity_id,task_code,details,priority)
SELECT 'offering',id,'verify_local_availability','Confirm a currently authorized provider offers the procedure in this destination and write unique local content.','high' FROM offerings;
INSERT INTO editorial_todos(entity_type,entity_id,task_code,details,priority)
SELECT 'treatment',id,'clinical_review','Review against current specialty guidelines and obtain qualified medical review.','high' FROM treatments;
INSERT INTO editorial_todos(entity_type,entity_id,task_code,details,priority)
SELECT 'clinic',id,'verify_identity_and_license','Verify hospital website, current identity, tourism authorization where required and actual procedure availability.','high' FROM clinics;
INSERT INTO editorial_todos(entity_type,entity_id,task_code,details,priority)
SELECT 'blog',id,'research_and_write','Replace placeholder with a sourced, destination-specific editorial guide before publication.','normal' FROM blogs;

INSERT INTO site_settings (setting_key,setting_value) VALUES
('SITE_URL','https://www.health-tours.com'),
('CANONICAL_HOST','www.health-tours.com'),
('DEFAULT_LANGUAGE','en'),
('DEFAULT_ROOT_REDIRECT','/en'),
('TRAILING_SLASH_POLICY','remove_except_root'),
('SUPPORTED_LANGUAGE_CODES','en,fa,tr,ar,de,fr,es,it,pt,ru,zh,ja,ko,hi,th,id,vi,he,el,cs,hu,pl,nl,sv,no,da,fi,ur,az,kk,uz,ro'),
('PUBLICATION_POLICY','review_before_publish'),
('MEDICAL_REVIEW_REQUIRED','true'),
('ALLOW_UNVERIFIED_OFFERINGS','false'),
('ALLOW_UNVERIFIED_PRICES','false'),
('IRAN_TRAVEL_AND_PAYMENT_REVIEW_REQUIRED','true');

INSERT INTO schema_migrations (version) VALUES
('2026.10.28-rebuilt-clean-install-v2.1');

-- EXPECTED SEED COUNTS: languages=32, currencies=26, countries=26, cities=69, Turkey cities=30, Iran cities=15, treatments=20, offerings=1380, master FAQs=200, offering draft FAQs=13800, draft SEO records=1495, clinics=14, source leads=25, draft blogs=69.
-- POST-IMPORT CHECKS:
SELECT 'languages' AS entity, COUNT(*) AS total FROM languages
UNION ALL SELECT 'countries',COUNT(*) FROM countries
UNION ALL SELECT 'cities',COUNT(*) FROM cities
UNION ALL SELECT 'treatments',COUNT(*) FROM treatments
UNION ALL SELECT 'offerings',COUNT(*) FROM offerings
UNION ALL SELECT 'treatment_faqs',COUNT(*) FROM treatment_faqs
UNION ALL SELECT 'faqs',COUNT(*) FROM faqs
UNION ALL SELECT 'seo_records',COUNT(*) FROM seo_records
UNION ALL SELECT 'clinics',COUNT(*) FROM clinics
UNION ALL SELECT 'doctors',COUNT(*) FROM doctors
UNION ALL SELECT 'blogs',COUNT(*) FROM blogs
UNION ALL SELECT 'prices',COUNT(*) FROM prices;
SELECT co.code,COUNT(ci.id) AS city_count FROM countries co JOIN cities ci ON ci.country_id=co.id WHERE co.code IN ('TR','IR') GROUP BY co.code;
SELECT COUNT(*) AS unexpectedly_published_offerings FROM offerings WHERE status='published';
SELECT COUNT(*) AS unexpectedly_indexable_seo_records FROM seo_records WHERE robots_policy='index';
SELECT TABLE_NAME,CONSTRAINT_NAME,REFERENCED_TABLE_NAME FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() ORDER BY TABLE_NAME,CONSTRAINT_NAME;
-- END.

-- Unverified editorial staging. All 1380 records remain draft and noindex.
CREATE TABLE offering_editorial_drafts (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 offering_id BIGINT UNSIGNED NOT NULL,
 lang VARCHAR(12) NOT NULL DEFAULT 'en',
 title VARCHAR(500) NOT NULL,
 body LONGTEXT NOT NULL,
 provenance VARCHAR(100) NOT NULL DEFAULT 'generated_unverified_draft',
 medical_review_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 local_review_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 status ENUM('draft','review','published','archived') NOT NULL DEFAULT 'draft',
 robots_policy ENUM('noindex','index') NOT NULL DEFAULT 'noindex',
 UNIQUE KEY uq_editorial_offering_lang(offering_id,lang),
 CONSTRAINT fk_ed_offering FOREIGN KEY(offering_id) REFERENCES offerings(id),
 CONSTRAINT fk_ed_lang FOREIGN KEY(lang) REFERENCES languages(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
