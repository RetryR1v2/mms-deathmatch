CREATE TABLE `mms_deathmatch` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`charidentifier` INT(11) NOT NULL,
	`firstname` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'armscii8_general_ci',
	`lastname` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'armscii8_general_ci',
	`kills` INT(11) NOT NULL DEFAULT '0',
	`deaths` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='armscii8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=6
;
