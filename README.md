# Cuerpo General de Bomberos Voluntarios del Perú

Este proyecto es una aplicación Flutter en desarrollo para apoyar las operaciones del **Cuerpo General de Bomberos Voluntarios del Perú (CGBVP)**. La aplicación se enfoca en la gestión de recursos, formularios dinámicos, autenticación, geolocalización y otros servicios relacionados con las Unidades Básicas Operativas (UBO) de la organización.

## Requisitos Previos

Antes de comenzar, asegúrate de que tu entorno de desarrollo esté correctamente configurado:

- **Flutter**: Instalar Flutter SDK. Instrucciones [aquí](https://flutter.dev/docs/get-started/install).
- **Firebase**: El proyecto utiliza varios servicios de Firebase (Auth, Firestore). Asegúrate de tener acceso al archivo `google-services.json` configurado correctamente para Android.
- **Android SDK**: Asegúrate de tener instalada la versión 34 del SDK de Android.
- **Node.js y npm**: Requeridos para algunos scripts adicionales.

### Plugins principales utilizados:

- Firebase Core
- Firebase Auth
- Firestore
- Google Sign-In
- Flutter Local Notifications

## Configuración del Entorno

### Clonar el repositorio:

```bash
git clone https://github.com/tu-repositorio/cgbvp-app.git
```
### Instalar dependencias:

Navega al directorio del proyecto y ejecuta:

```bash
flutter pub get
```

### Configurar Firebase:

Coloca el archivo `google-services.json` en `android/app/` para que Firebase funcione correctamente.

### Actualizar Gradle:

Verifica que el archivo `android/build.gradle` tenga la versión correcta del SDK:

```gradle
compileSdkVersion 34
targetSdkVersion 34
minSdkVersion 23
```
### IDX Integración:

Si estás trabajando con IDX (especificar más detalles si aplica), sigue la configuración del sistema de índices o cualquier API relacionada, según la documentación técnica interna.

## Ejecución de la Aplicación

Para ejecutar la aplicación en modo debug:

```bash
flutter run
```
### Para construir la aplicación en modo release (producción):

```bash
flutter build apk
```
## Desarrollo y Contribución

Este proyecto utiliza las siguientes tecnologías y herramientas:

- **Dart**: Lenguaje de programación usado en Flutter.
- **Firebase**: Autenticación, base de datos en tiempo real y notificaciones.
- **Material Design 3**: Implementación visual moderna en Flutter.
- **IDX**: Integración específica para la gestión de índices o datos (detalles pendientes).

### Buenas Prácticas

- **Hot Reload**: Utiliza `flutter run` y guarda cambios para probar rápidamente nuevas funcionalidades.
- **Rutas Navegación**: Las rutas entre páginas están manejadas de manera centralizada en el archivo `main.dart`.
- **Estado Global**: Evitar el uso de variables globales. Utiliza patrones como `Provider` o `Riverpod` si es necesario manejar estados complejos.

## Documentación Adicional

- [Guía de Estilos Flutter](https://flutter.dev/docs/development/ui/widgets)
- [Documentación de Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Guía para Integrar IDX](#) <!-- Reemplaza con el enlace correspondiente si está disponible -->

## Contacto y Soporte

Si tienes dudas o necesitas soporte técnico, contacta con el equipo de desarrollo en [email@cgbvp.gob.pe](mailto:email@cgbvp.gob.pe).


