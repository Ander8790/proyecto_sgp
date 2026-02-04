# Análisis del Proyecto SGP

Este documento detalla los hallazgos tras el análisis del código fuente del Sistema de Gestión de Pasantes (SGP). Se incluyen puntos críticos que impiden el funcionamiento, mejoras sugeridas y mejores prácticas recomendadas.

## 1. Puntos Críticos (Critical Points)

Estos problemas deben ser resueltos inmediatamente para que la aplicación funcione.

### 1.1. Archivo de Configuración Faltante
*   **Problema:** El archivo `app/config/config.php` es requerido en `public/index.php` pero no existe en el repositorio.
*   **Impacto:** La aplicación arrojará un error fatal al intentar iniciar.
*   **Solución:** Se ha generado un archivo `config.sample.php` como plantilla. Debe renombrarse a `config.php` y configurarse con las credenciales locales.

### 1.2. Inconsistencia Crítica: Base de Datos vs Código
*   **Problema:** Existe una desconexión total entre los archivos SQL proporcionados (`sql/database.sql`, `sql/sgp_schema.sql`) y el código PHP (`UserModel.php`).
    *   **SQL:** Usa tablas en inglés: `users`, `roles`, `security_questions`.
    *   **Código:** Usa tablas en español: `usuarios`, `datos_personales`, `preguntas_seguridad`, `roles` (con columna `nombre`), `departamentos`.
    *   **Tablas Faltantes:** El código hace referencia a una tabla `datos_personales` y `departamentos` que NO existen en los scripts SQL originales.
*   **Impacto:** El sistema de Login y Registro fallará completamente (Error SQL: "Table doesn't exist").
*   **Solución:** Se ha generado un archivo `sql/corrected_schema.sql` basado en la ingeniería inversa del código PHP actual.

## 2. Mejoras Sugeridas (Improvements)

### 2.1. Gestión de Dependencias
*   **Actual:** Se usan `require_once` manuales para cargar clases. Las librerías de JS se gestionan con `npm` pero las de PHP no tienen gestor.
*   **Mejora:** Implementar **Composer**.
    *   Crear un `composer.json`.
    *   Usar PSR-4 Autoloading para cargar clases automáticamente (`App\Controllers`, `App\Models`).
    *   Eliminar la lista larga de `require_once` en `index.php`.

### 2.2. Estandarización de Idioma
*   **Actual:** Mezcla de Inglés (`users`, `AuthController`) y Español (`usuarios`, `datos_personales`).
*   **Mejora:** Estandarizar a uno solo (preferiblemente Inglés para código/base de datos, Español para vistas).

### 2.3. Seguridad
*   **Validación:** Se usa `Validator`, lo cual es bueno.
*   **Mejora:** Implementar Tokens CSRF en todos los formularios POST para prevenir ataques Cross-Site Request Forgery.
*   **Mejora:** Mover credenciales sensibles a variables de entorno (`.env`) usando una librería como `vlucas/phpdotenv`.

## 3. Mejores Prácticas (Best Practices)

### 3.1. Arquitectura
*   **Modelos:** Actualmente los modelos contienen SQL puro. Se recomienda usar un **Query Builder** o un **ORM** (como Eloquent o Doctrine) para:
    *   Abstraer la base de datos (seguridad y portabilidad).
    *   Mejorar la legibilidad (`User::find(1)` vs `SELECT * FROM...`).
*   **Controladores:** Mover la lógica de negocio compleja ("Nivel 2: Verificación de Perfil") a **Servicios** dedicados (ej: `ProfileService`), dejando los controladores solo para gestionar HTTP.

### 3.2. Testing
*   **Actual:** No hay tests (`npm test` falla).
*   **Mejora:** Instalar **PHPUnit** y escribir tests para:
    *   Autenticación (Login exitoso/fallido).
    *   Registro de usuarios.
    *   Validación de permisos (Roles).

### 3.3. Dockerización
*   Crear un `Dockerfile` y `docker-compose.yml` para facilitar el despliegue y desarrollo en cualquier máquina sin configurar XAMPP/WAMP manualmente.

## Resumen de Archivos Generados
Para facilitar la corrección, se han agregado al proyecto:
1.  `sgp/sql/corrected_schema.sql`: Esquema de base de datos que **SÍ funciona** con el código actual.
2.  `sgp/app/config/config.sample.php`: Plantilla de configuración.
