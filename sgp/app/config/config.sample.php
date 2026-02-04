<?php
// Configuración de la Base de Datos
$config = [
    'host'    => 'localhost',
    'name'    => 'sgp',
    'user'    => 'root',
    'pass'    => '',
    'charset' => 'utf8mb4'
];

// Configuración de la App
define('SITENAME', 'SGP - Sistema de Gestión de Pasantes');
define('APPVERSION', '1.0.0');

// Zona Horaria
date_default_timezone_set('America/Caracas'); // Ajustar según ubicación
