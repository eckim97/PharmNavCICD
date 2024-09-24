-- Drop the table if it exists
DROP TABLE IF EXISTS `pharmacy`;

-- Create the pharmacy table
CREATE TABLE `pharmacy` (
                            `id` bigint(20) NOT NULL AUTO_INCREMENT,
                            `created_date` datetime(6) DEFAULT NULL,
                            `modified_date` datetime(6) DEFAULT NULL,
                            `latitude` double NULL,
                            `longitude` double NULL,
                            `pharmacy_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                            `pharmacy_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Set necessary MySQL settings
SET @OLD_TIME_ZONE = @@time_zone;
SET time_zone = '+00:00';
SET @OLD_UNIQUE_CHECKS = @@unique_checks, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@foreign_key_checks, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@sql_mode, SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET @OLD_SQL_NOTES = @@sql_notes, SQL_NOTES = 0;
SET GLOBAL local_infile = 1;

-- Load data from CSV file
LOAD DATA INFILE '/docker-entrypoint-initdb.d/pharmacy.csv'
    INTO TABLE pharmacy
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    ESCAPED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    (@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14, @col15)
    SET
        pharmacy_name = @col2,
        pharmacy_address = @col3,
        latitude = @col4,
        longitude = @col5,
        created_date = NOW(),
        modified_date = NOW();

-- Reset MySQL settings
SET time_zone = @OLD_TIME_ZONE;
SET unique_checks = @OLD_UNIQUE_CHECKS;
SET foreign_key_checks = @OLD_FOREIGN_KEY_CHECKS;
SET sql_mode = @OLD_SQL_MODE;
SET sql_notes = @OLD_SQL_NOTES;