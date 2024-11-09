# Control Vacario App

Control Vacario App es una aplicación de Flutter diseñada para gestionar vacas, remedios y usuarios en una finca o establecimiento agrícola. La aplicación permite realizar operaciones CRUD (Crear, Leer, Actualizar y Eliminar) para la gestión de vacas y remedios, y proporciona un sistema de autenticación para los usuarios.

## Características

- **Autenticación**: Autenticación de usuarios con tokens JWT para proteger los endpoints de la API.
- **Gestión de Vacas**: Crea, lee, actualiza y elimina información sobre las vacas, incluyendo su tipo y estado.
- **Gestión de Remedios**: Administra remedios veterinarios con opciones para agregar, editar y eliminar.
- **Pantallas Dinámicas**: Listas que se actualizan automáticamente al agregar, editar o eliminar elementos, con opción de refresco mediante "pull-to-refresh".
- **Navegación Simple**: Navegación entre pantallas para facilitar la administración de los recursos.

## Requisitos Previos

- **Flutter**: Instalación de [Flutter SDK](https://flutter.dev/docs/get-started/install).
- **API Backend**: La aplicación requiere una API en Spring Boot que provee los endpoints de autenticación y gestión de vacas y remedios : https://github.com/titorjs/control-vacario-api
- **Conexión a Internet**: La aplicación necesita acceso a la red para conectarse a la API.

## Instalación y Configuración

1. **Clonar el Repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/control-vacario-app.git
   cd control-vacario-app

2. **Correr la aplicación**:
   ```bash
   flutter run