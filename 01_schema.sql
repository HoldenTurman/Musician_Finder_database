-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema musician_finder
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `musician_finder` ;

-- -----------------------------------------------------
-- Schema musician_finder
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `musician_finder` DEFAULT CHARACTER SET utf8 ;
USE `musician_finder` ;

-- -----------------------------------------------------
-- Table `musician_finder`.`musician`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`musician` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`musician` (
  `musician_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `f_name` VARCHAR(55) NOT NULL,
  `l_name` VARCHAR(65) NOT NULL,
  `contact_email` VARCHAR(65) NULL,
  PRIMARY KEY (`musician_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `musician_finder`.`instrument`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`instrument` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`instrument` (
  `instrument_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `instrument_name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`instrument_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `musician_finder`.`musician_instrument`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`musician_instrument` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`musician_instrument` (
  `musician_instrament_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `years_experience` INT NOT NULL,
  `demo_video_url` VARCHAR(550) NULL,
  `musician_id` INT UNSIGNED NOT NULL,
  `instrument_id` INT UNSIGNED NOT NULL,
  `skill_level_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`musician_instrament_id`),
  INDEX `fk_musician_instrament_musician_idx` (`musician_id` ASC) VISIBLE,
  INDEX `fk_musician_instrament_instrument1_idx` (`instrument_id` ASC) VISIBLE,
  CONSTRAINT `fk_musician_instrament_musician`
    FOREIGN KEY (`musician_id`)
    REFERENCES `musician_finder`.`musician` (`musician_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_musician_instrament_instrument1`
    FOREIGN KEY (`instrument_id`)
    REFERENCES `musician_finder`.`instrument` (`instrument_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `musician_finder`.`vendor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`vendor` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`vendor` (
  `vendor_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `vendor_name` VARCHAR(70) NOT NULL,
  `contact_email` VARCHAR(100) NOT NULL,
  `zip_code` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`vendor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `musician_finder`.`gig_listing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`gig_listing` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`gig_listing` (
  `gig_listing_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `gig_title` VARCHAR(100) NOT NULL,
  `gig_date` DATETIME NOT NULL,
  `pay_amount` DECIMAL(10,2) NULL,
  `demo_video_required` TINYINT NULL,
  `vendor_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`gig_listing_id`),
  INDEX `fk_gig_listing_vendor1_idx` (`vendor_id` ASC) VISIBLE,
  CONSTRAINT `fk_gig_listing_vendor1`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `musician_finder`.`vendor` (`vendor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `musician_finder`.`application_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`application_status` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`application_status` (
  `application_status_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_name` VARCHAR(13) NOT NULL,
  `application_result_description` TEXT NOT NULL,
  PRIMARY KEY (`application_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `musician_finder`.`gig_lineup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`gig_lineup` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`gig_lineup` (
  `gig_lineup_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `applied_at` DATETIME NOT NULL,
  `notes` TEXT NULL,
  `musician_id` INT UNSIGNED NOT NULL,
  `gig_listing_id` INT UNSIGNED NOT NULL,
  `application_status_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`gig_lineup_id`),
  INDEX `fk_gig_lineup_musician1_idx` (`musician_id` ASC) VISIBLE,
  INDEX `fk_gig_lineup_gig_listing1_idx` (`gig_listing_id` ASC) VISIBLE,
  INDEX `fk_gig_lineup_application_status1_idx` (`application_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_gig_lineup_musician1`
    FOREIGN KEY (`musician_id`)
    REFERENCES `musician_finder`.`musician` (`musician_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gig_lineup_gig_listing1`
    FOREIGN KEY (`gig_listing_id`)
    REFERENCES `musician_finder`.`gig_listing` (`gig_listing_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gig_lineup_application_status1`
    FOREIGN KEY (`application_status_id`)
    REFERENCES `musician_finder`.`application_status` (`application_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE `musician_finder`;

-- CREATE TABLE
CREATE TABLE skill_level (
    skill_level_id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    skill_name VARCHAR(10) NOT NULL,
    skill_description TEXT NOT NULL
);
-- CREATED TABLE HAS CORRECT FOREIGN KEYS/RELATIONSHIPS
ALTER TABLE `musician_instrument`
ADD CONSTRAINT `fk_musician_instrument_skill_level`
FOREIGN KEY (`skill_level_id`)
REFERENCES `skill_level` (`skill_level_id`)
ON DELETE NO ACTION
ON UPDATE NO ACTION;



-- -----------------------------------------------------
-- Table `musician_finder`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`genre` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`genre` (
  `genre_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `genre_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`genre_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `musician_finder`.`musician_genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`musician_genre` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`musician_genre` (
  `musician_id` INT UNSIGNED NOT NULL,
  `genre_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`musician_id`, `genre_id`),
  INDEX `fk_musician_genre_musician1_idx` (`musician_id` ASC) VISIBLE,
  INDEX `fk_musician_genre_genre1_idx` (`genre_id` ASC) VISIBLE,
  CONSTRAINT `fk_musician_genre_musician1`
    FOREIGN KEY (`musician_id`)
    REFERENCES `musician_finder`.`musician` (`musician_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_musician_genre_genre1`
    FOREIGN KEY (`genre_id`)
    REFERENCES `musician_finder`.`genre` (`genre_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `musician_finder`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `musician_finder`.`review` ;

CREATE TABLE IF NOT EXISTS `musician_finder`.`review` (
  `review_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rating` TINYINT UNSIGNED NOT NULL,
  `comments` TEXT NULL,
  `created_at` DATETIME NOT NULL,
  `gig_listing_id` INT UNSIGNED NOT NULL,
  `vendor_id` INT UNSIGNED NOT NULL,
  `musician_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`review_id`),
  INDEX `fk_review_gig_listing1_idx` (`gig_listing_id` ASC) VISIBLE,
  INDEX `fk_review_vendor1_idx` (`vendor_id` ASC) VISIBLE,
  INDEX `fk_review_musician1_idx` (`musician_id` ASC) VISIBLE,
  CONSTRAINT `fk_review_gig_listing1`
    FOREIGN KEY (`gig_listing_id`)
    REFERENCES `musician_finder`.`gig_listing` (`gig_listing_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_vendor1`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `musician_finder`.`vendor` (`vendor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_musician1`
    FOREIGN KEY (`musician_id`)
    REFERENCES `musician_finder`.`musician` (`musician_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;





