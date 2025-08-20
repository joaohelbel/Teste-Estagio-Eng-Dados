-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema livraria_dw
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema livraria_dw
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `livraria_dw` DEFAULT CHARACTER SET utf8MB4 ;
-- -----------------------------------------------------
-- Schema livraria_dw
-- -----------------------------------------------------
USE `livraria_dw` ;

-- -----------------------------------------------------
-- Table `livraria_dw`.`Dim_Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_dw`.`Dim_product` (
  `product_key` INT NOT NULL auto_increment,
  `product_id` int unique,
  `product_name` VARCHAR(255) NULL,
  `category` VARCHAR(255) NULL,
  `subcategory` VARCHAR(255) NULL,
  `cost` DECIMAL(18,2) NULL,
  `list_price` DECIMAL(18,2) NULL,
  PRIMARY KEY (`product_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `livraria_dw`.`Dim_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_dw`.`Dim_location` (
  `location_key` INT NOT NULL auto_increment,
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(45) NULL,
  PRIMARY KEY (`location_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `livraria_dw`.`Dim_Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_dw`.`Dim_customer` (
  `customer_key` INT NOT NULL auto_increment,
  `signup_date` DATE NULL,
  `segment` VARCHAR(45) NULL,
  `location_key` INT NOT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `ix_customer_location` (`location_key`),
  CONSTRAINT `fk_customer_location`
    FOREIGN KEY (`location_key`) REFERENCES `dim_location` (`location_key`)
    ON UPDATE NO ACTION ON DELETE NO ACTION
)ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `livraria_dw`.`Dim_Canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_dw`.`Dim_channel` (
  `channel_key` INT NOT NULL auto_increment,
  `channel` VARCHAR(45) NULL,
  PRIMARY KEY (`channel_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `livraria_dw`.`Dim_calendario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_dw`.`Dim_calendar` (
  `calendar_key` INT NOT NULL auto_increment,
  `date` DATE NOT NULL,
  `ano` INT NOT NULL,
  `mes` INT NOT NULL,
  `yyyymm` INT NOT NULL,
  PRIMARY KEY (`calendar_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `livraria_dw`.`Fato_vendas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fact_sales`;
CREATE TABLE `fact_sales` (
  `sales_key`       INT NOT NULL AUTO_INCREMENT,
  `customer_key`    INT NOT NULL,
  `product_key`     INT NOT NULL,
  `calendar_key`    INT NOT NULL,
  `channel_key`     INT NOT NULL,
  `qty`             INT,
  `unit_price`      DECIMAL(18,2),
  `discount`        DECIMAL(18,2),
  `gross_amount`    DECIMAL(18,2),
  `discount_amount` DECIMAL(18,2),
  `net_amount`      DECIMAL(18,2),
  PRIMARY KEY (`sales_key`),
  KEY `ix_fs_customer` (`customer_key`),
  KEY `ix_fs_product`  (`product_key`),
  KEY `ix_fs_calendar` (`calendar_key`),
  KEY `ix_fs_channel`  (`channel_key`),
  CONSTRAINT `fk_fs_customer`
    FOREIGN KEY (`customer_key`) REFERENCES `dim_customer` (`customer_key`)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT `fk_fs_product`
    FOREIGN KEY (`product_key`)  REFERENCES `dim_product` (`product_key`)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT `fk_fs_calendar`
    FOREIGN KEY (`calendar_key`) REFERENCES `dim_calendar` (`calendar_key`)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT `fk_fs_channel`
    FOREIGN KEY (`channel_key`)  REFERENCES `dim_channel` (`channel_key`)
    ON UPDATE NO ACTION ON DELETE NO ACTION
) ENGINE=InnoDB;



-- -----------------------------------------------------
-- Table `livraria_dw`.`quality_check_runs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_dw`.`quality_check_runs` (
  `runs_id` INT NOT NULL auto_increment,
  `check_name` VARCHAR(120) NULL,
  `severity` ENUM('ERROR', 'WARN') NOT NULL,
  `is_pass` TINYINT(1) NULL,
  `affected_cnt` INT NULL,
  `details` TEXT NULL,
  `run_ts` TIMESTAMP NULL,
  PRIMARY KEY (`runs_id`))
ENGINE = InnoDB;

-- facilitador para a busca do cliente
ALTER TABLE livraria_dw.dim_customer
  ADD COLUMN customer_id INT UNIQUE AFTER customer_key;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
