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
  `route` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Procedure structure for table `publish_message`
--
DROP PROCEDURE IF EXISTS acme.publish_message;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` PROCEDURE `acme`.`publish_message`( IN routing VARCHAR(255), IN id int, IN first_name VARCHAR(255), IN last_name  VARCHAR(255), IN email VARCHAR(255))
BEGIN
   SET @AMQP_URL = 'amqp://guest:guest@rabbitmq:5672';
   SET @AMQP_EXCHANGE = 'contacts.exchange';
   SET @MESSAGE = json_object('id', id, 'first_name', first_name, 'last_name', last_name, 'email', email);
  
   INSERT INTO logs (message) VALUES (@MESSAGE);
   
   SET @message_id = (SELECT lib_mysqludf_amqp_sendjson(@AMQP_URL, @AMQP_EXCHANGE, routing, @MESSAGE));
END$$
DELIMITER ;

--
-- Trigger structure for `pubmess_oninsert_trigger`
--
DROP TRIGGER IF EXISTS acme.pubmess_oninsert_trigger;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` TRIGGER pubmess_oninsert_trigger  
AFTER INSERT ON contacts 
FOR EACH ROW CALL publish_message('contacts.insert', NEW.id, NEW.first_name, NEW.last_name, NEW.email)$$
DELIMITER ;

--
-- Trigger structure for `pubmess_onupdate_trigger`
--
DROP TRIGGER IF EXISTS acme.pubmess_onupdate_trigger;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` TRIGGER pubmess_onupdate_trigger  
AFTER UPDATE ON contacts 
FOR EACH ROW CALL publish_message('contacts.update', NEW.id, NEW.first_name, NEW.last_name, NEW.email)$$
DELIMITER ;

--
-- Trigger structure for `pubmess_ondelete_trigger`
--
DROP TRIGGER IF EXISTS acme.pubmess_ondelete_trigger;
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` TRIGGER `pubmess_ondelete_trigger` 
AFTER DELETE ON contacts 
FOR EACH ROW CALL publish_message('contacts.delete', OLD.id, OLD.first_name, OLD.last_name, OLD.email)$$
DELIMITER ;

--
-- MySQL UDF definitions
--
USE mysql;

DROP FUNCTION IF EXISTS lib_mysqludf_amqp_info;
DROP FUNCTION IF EXISTS lib_mysqludf_amqp_sendjson;
DROP FUNCTION IF EXISTS lib_mysqludf_amqp_sendstring;

CREATE FUNCTION lib_mysqludf_amqp_info RETURNS STRING SONAME 'lib_mysqludf_amqp.so';
CREATE FUNCTION lib_mysqludf_amqp_sendjson RETURNS STRING SONAME 'lib_mysqludf_amqp.so';
CREATE FUNCTION lib_mysqludf_amqp_sendstring RETURNS STRING SONAME 'lib_mysqludf_amqp.so';