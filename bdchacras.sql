USE bdchacras;

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    documento INT NOT NULL,
    numero_W VARCHAR(255),
    ubicacion VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    remember_token VARCHAR(100),
    mensaje TEXT NULL,
    bloqueado BOOLEAN NOT NULL DEFAULT TRUE,
    es_administrador BOOLEAN NOT NULL DEFAULT FALSE,
    es_publicador BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

drop table publicaciones;

CREATE TABLE publicaciones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido VARCHAR(255) NOT NULL,
    imagen VARCHAR(255),
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE password_reset_tokens (
    email VARCHAR(255) PRIMARY KEY,
    token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL
);

CREATE TABLE failed_jobs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    connection TEXT NOT NULL,
    queue TEXT NOT NULL,
    payload LONGTEXT NOT NULL,
    exception LONGTEXT NOT NULL,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE personal_access_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tokenable_type VARCHAR(255) NOT NULL,
    tokenable_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    token VARCHAR(64) NOT NULL UNIQUE,
    abilities TEXT NULL,
    last_used_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM users;

INSERT INTO publicaciones (titulo, contenido, imagen, user_id)
VALUES ('Título de prueba', 'Contenido de prueba', NULL, 1);

INSERT INTO publicaciones (titulo, contenido, user_id)
VALUES ('Título de prueba2', 'Contenido de prueba2,',4);

select * from publicaciones;

INSERT INTO users (nombre, documento, numero_W, ubicacion, email, password, es_administrador, es_publicador, bloqueado)
VALUES ('Admin', 12345678, '123456789', 'Ubicacion Admin', 'admin@admin.com', 'admin123', TRUE, TRUE, FALSE);

SELECT * FROM Users WHERE bloqueado = true;
SELECT * FROM publicaciones ORDER BY updated_at DESC LIMIT 5;

SHOW GRANTS FOR 'root'@'localhost';

SELECT user, host FROM mysql.user;

SHOW TABLES;

SHOW CREATE TABLE publicaciones;


