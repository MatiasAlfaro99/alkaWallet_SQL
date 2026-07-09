CREATE DATABASE AlkeWallet;
USE AlkeWallet;

CREATE TABLE moneda (
    currency_id INT AUTO_INCREMENT PRIMARY KEY,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL
);

CREATE TABLE usuario (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0.00
);

ALTER TABLE usuario ADD COLUMN fecha_creacion DATE;

CREATE TABLE transaccion (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT,
    receiver_user_id INT,
    importe DECIMAL(10,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    currency_id INT,
    FOREIGN KEY (sender_user_id) REFERENCES usuario(user_id),
    FOREIGN KEY (receiver_user_id) REFERENCES usuario(user_id),
    FOREIGN KEY (currency_id) REFERENCES moneda(currency_id)
);

INSERT INTO moneda (currency_name, currency_symbol) VALUES 
('Dolar', 'USD'), ('Peso Argentino', 'ARS'), ('Euro', 'EUR');

INSERT INTO usuario (nombre, correo_electronico, contrasena, saldo, fecha_creacion) VALUES
('Matias', 'matias@mail.com', 'pass123', 500.00, '2023-01-01'),
('Juan', 'juan@mail.com', 'pass123', 1000.00, '2023-02-01'),
('Ana', 'ana@mail.com', 'pass123', 1500.00, '2023-03-01');

INSERT INTO transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES
(2, 1, 100.00, 1),
(3, 1, 200.00, 1),
(3, 2, 50.00, 2);


SELECT * FROM usuario;

SELECT * FROM usuario WHERE saldo > 1000;

SELECT t.transaction_id, u_sender.nombre AS envia, u_receiver.nombre AS recibe, t.importe, m.currency_symbol
FROM transaccion t
INNER JOIN usuario u_sender ON t.sender_user_id = u_sender.user_id
INNER JOIN usuario u_receiver ON t.receiver_user_id = u_receiver.user_id
INNER JOIN moneda m ON t.currency_id = m.currency_id;

SELECT u.nombre, (SELECT COUNT(*) FROM transaccion t WHERE t.sender_user_id = u.user_id) AS total_envios
FROM usuario u;

SELECT SUM(importe) AS total_movido FROM transaccion;

SELECT DISTINCT m.currency_name FROM moneda m 
JOIN transaccion t ON m.currency_id = t.currency_id WHERE t.sender_user_id = 2;

SELECT * FROM transaccion;

SELECT * FROM transaccion WHERE sender_user_id = 1 OR receiver_user_id = 1;

CREATE VIEW Top5Usuarios AS
SELECT nombre, saldo FROM usuario ORDER BY saldo DESC LIMIT 5;


UPDATE usuario SET correo_electronico = 'matias_actualizado@mail.com' WHERE user_id = 1;

DELETE FROM transaccion WHERE transaction_id = 3;

START TRANSACTION;
UPDATE usuario SET saldo = saldo - 100 WHERE user_id = 2;
UPDATE usuario SET saldo = saldo + 100 WHERE user_id = 1;
INSERT INTO transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (2, 1, 100.00, 1);
COMMIT;

START TRANSACTION;
INSERT INTO transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (999, 1, 50.00, 1);
ROLLBACK;
