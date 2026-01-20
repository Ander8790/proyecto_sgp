-- ============================================
-- BASE DE DATOS: SGP (Esquema Corregido)
-- Basado en ingeniería inversa de UserModel.php
-- ============================================

CREATE DATABASE IF NOT EXISTS sgp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sgp;

-- =========================
-- TABLA: roles
-- =========================
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT IGNORE INTO roles (id, nombre) VALUES
(1, 'Administrador'),
(2, 'Tutor'),
(3, 'Pasante');

-- =========================
-- TABLA: departamentos
-- =========================
CREATE TABLE IF NOT EXISTS departamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT IGNORE INTO departamentos (nombre) VALUES
('Recursos Humanos'),
('Tecnología'),
('Administración');

-- =========================
-- TABLA: usuarios
-- =========================
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    departamento_id INT DEFAULT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    requiere_cambio_clave TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (rol_id) REFERENCES roles(id),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
) ENGINE=InnoDB;

-- =========================
-- TABLA: datos_personales (Nivel 2)
-- =========================
CREATE TABLE IF NOT EXISTS datos_personales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    genero CHAR(1),
    fecha_nacimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- TABLA: preguntas_seguridad
-- =========================
CREATE TABLE IF NOT EXISTS preguntas_seguridad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pregunta VARCHAR(255) NOT NULL,
    activa TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

INSERT IGNORE INTO preguntas_seguridad (id, pregunta) VALUES
(1, '¿Cuál es el nombre de tu primera mascota?'),
(2, '¿En qué ciudad naciste?'),
(3, '¿Cuál es tu comida favorita?'),
(4, '¿Nombre de tu escuela primaria?'),
(5, '¿Cuál es tu color favorito?');

-- =========================
-- TABLA: usuarios_respuestas
-- =========================
CREATE TABLE IF NOT EXISTS usuarios_respuestas (
    usuario_id INT NOT NULL,
    pregunta_id INT NOT NULL,
    respuesta_hash VARCHAR(255) NOT NULL,

    PRIMARY KEY (usuario_id, pregunta_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas_seguridad(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================
-- DATOS INICIALES (Admin)
-- =========================
-- Password: admin (hash de ejemplo, cambiar en producción)
INSERT IGNORE INTO usuarios (correo, password, rol_id, estado, requiere_cambio_clave) VALUES
('admin@sgp.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'activo', 0);
