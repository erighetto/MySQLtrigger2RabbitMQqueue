USE acme;

--
-- Table structure for table `contacts`
--
DROP TABLE IF EXISTS `contacts`;
CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `logs`
--
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Procedure structure for table `publish_message`
--
DROP PROCEDURE IF EXISTS acme.publish_message;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` PROCEDURE `acme`.`publish_message`(IN first_name VARCHAR(255), IN last_name  VARCHAR(255), IN email VARCHAR(255))
BEGIN
   DECLARE cmd TEXT;
   DECLARE result int(10);
  
   SET cmd=CONCAT('bash /opt/pubmess.sh "',
   first_name,
   '" "',
   last_name,
   '" "',
   email,
   '"');
  
   INSERT INTO logs (message) VALUES (cmd);
   
  SET result = sys_exec(cmd);
END$$
DELIMITER ;

--
-- Trigger structure for table `pubmess_oninsert_trigger`
--
DROP TRIGGER IF EXISTS acme.pubmess_oninsert_trigger;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` TRIGGER pubmess_oninsert_trigger  
AFTER INSERT ON contacts 
FOR EACH ROW CALL publish_message(NEW.first_name, NEW.last_name, NEW.email)$$
DELIMITER ;

--
-- Trigger structure for table `pubmess_onupdate_trigger`
--
DROP TRIGGER IF EXISTS acme.pubmess_onupdate_trigger;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` TRIGGER pubmess_onupdate_trigger  
AFTER UPDATE ON contacts 
FOR EACH ROW CALL publish_message(NEW.first_name, NEW.last_name, NEW.email)$$
DELIMITER ;

--
-- MySQL UDF definitions
--
USE mysql;

DROP FUNCTION IF EXISTS lib_mysqludf_sys_info;
DROP FUNCTION IF EXISTS sys_get;
DROP FUNCTION IF EXISTS sys_set;
DROP FUNCTION IF EXISTS sys_exec;
DROP FUNCTION IF EXISTS sys_eval;

CREATE FUNCTION lib_mysqludf_sys_info RETURNS string SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_get RETURNS string SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_set RETURNS int SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_exec RETURNS int SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_eval RETURNS string SONAME 'lib_mysqludf_sys.so';