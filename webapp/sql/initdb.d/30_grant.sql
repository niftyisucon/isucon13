CREATE USER 'isucon'@'%' IDENTIFIED BY 'isucon';
CREATE USER 'isucon'@'127.0.0.1' IDENTIFIED BY 'isucon';
CREATE USER 'isucon'@'localhost' IDENTIFIED BY 'isucon';
CREATE USER 'isudns'@'%' IDENTIFIED BY 'isudns';
CREATE USER 'isudns'@'127.0.0.1' IDENTIFIED BY 'isudns';
CREATE USER 'isudns'@'localhost' IDENTIFIED BY 'isudns';

GRANT ALL PRIVILEGES ON `isupipe`.* TO 'isucon'@'%';
GRANT ALL PRIVILEGES ON `isupipe`.* TO 'isucon'@'127.0.0.1';
GRANT ALL PRIVILEGES ON `isupipe`.* TO 'isucon'@'localhost';
GRANT ALL PRIVILEGES ON `isudns`.* TO 'isudns'@'%';
GRANT ALL PRIVILEGES ON `isudns`.* TO 'isudns'@'127.0.0.1';
GRANT ALL PRIVILEGES ON `isudns`.* TO 'isudns'@'localhost';

FLUSH PRIVILEGES;
