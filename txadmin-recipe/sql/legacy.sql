-- Legacy Native Alpha schema (Path B)
-- Run this once on a fresh database. Safe to re-run because we use IF NOT EXISTS.

CREATE TABLE IF NOT EXISTS legacy_users (
  license VARCHAR(64) NOT NULL,
  first_seen INT NOT NULL DEFAULT 0,
  last_seen INT NOT NULL DEFAULT 0,
  PRIMARY KEY (license)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS legacy_characters (
  cid INT NOT NULL AUTO_INCREMENT,
  license VARCHAR(64) NOT NULL,
  firstname VARCHAR(64) NOT NULL DEFAULT '',
  lastname VARCHAR(64) NOT NULL DEFAULT '',
  name VARCHAR(128) NOT NULL DEFAULT '',
  dob VARCHAR(16) NOT NULL DEFAULT '',
  gender VARCHAR(8) NOT NULL DEFAULT 'U',
  job LONGTEXT NULL,
  gang LONGTEXT NULL,
  money LONGTEXT NULL,
  metadata LONGTEXT NULL,
  created_at INT NOT NULL DEFAULT 0,
  PRIMARY KEY (cid),
  KEY idx_license (license)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS legacy_event_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  ts INT NOT NULL,
  src INT NOT NULL DEFAULT 0,
  event VARCHAR(64) NOT NULL,
  category VARCHAR(64) NOT NULL,
  meta LONGTEXT NULL,
  PRIMARY KEY (id),
  KEY idx_ts (ts),
  KEY idx_event (event)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS legacy_analytics (
  metric VARCHAR(64) NOT NULL,
  period VARCHAR(32) NOT NULL,
  value DOUBLE NOT NULL DEFAULT 0,
  calculated_at INT NOT NULL DEFAULT 0,
  PRIMARY KEY (metric, period)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optional tables referenced by legacy-public (safe stubs)
CREATE TABLE IF NOT EXISTS legacy_vehicles (
  id INT NOT NULL AUTO_INCREMENT,
  stolen TINYINT(1) NOT NULL DEFAULT 0,
  created_at INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_stolen (stolen),
  KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS legacy_vehicle_impound (
  id INT NOT NULL AUTO_INCREMENT,
  impounded_at INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_impounded (impounded_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed baseline metrics so dashboards are not empty
INSERT INTO legacy_analytics (metric, period, value, calculated_at)
VALUES
  ('AVG_RESPONSE_TIME','DAILY',0,UNIX_TIMESTAMP()),
  ('CALL_VOLUME_24H','DAILY',0,UNIX_TIMESTAMP()),
  ('EVIDENCE_ADMISSIBLE_PCT','DAILY',100,UNIX_TIMESTAMP()),
  ('GOV_BALANCE','DAILY',0,UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE value=VALUES(value), calculated_at=VALUES(calculated_at);
