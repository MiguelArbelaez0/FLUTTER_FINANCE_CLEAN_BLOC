# Flutter Finance Clean BLoC

Aplicación personal de finanzas desarrollada por Miguel Arbeláez Vallejo con Flutter, Dart, BLoC y persistencia local mediante Hive.

## Funcionalidades

- Crear, consultar, editar y eliminar ingresos y gastos.
- Registrar categoría, descripción, importe y fecha de cada movimiento.
- Consultar ingresos, gastos y saldo del mes seleccionado, incluyendo otros años.
- Conservar movimientos entre sesiones en el mismo dispositivo o navegador.
- Confirmar eliminaciones y mostrar errores de carga o escritura.

## Tecnologías y requisitos

Flutter, Dart, `flutter_bloc`, `hive`, `hive_flutter`, `intl` y `cupertino_icons` (iconos Cupertino utilizados por componentes de Flutter). Las pruebas utilizan `flutter_test` y las reglas de análisis, `flutter_lints`.

El proyecto requiere Dart compatible con `^3.10.7`. La validación local se realizó con Flutter **3.47.5** y Dart **3.13.4**; las versiones resueltas están en `pubspec.lock`.

## Arquitectura

La presentación envía eventos a BLoC; este coordina casos de uso y el contrato del repositorio. La implementación del repositorio delega la persistencia a una fuente de datos Hive. El cálculo de balance pertenece al dominio.

```text
lib/
├── app/                         # Tema y composición de dependencias
├── core/                        # Persistencia, utilidades y contratos comunes
└── features/finance/
    ├── data/                    # Modelos, fuente local y repositorio
    ├── domain/                  # Entidades, contratos y casos de uso
    └── presentation/            # BLoC, pantallas y widgets

test/finance_balance_test.dart   # Dominio, Hive, BLoC y widgets
```

Los eventos se procesan en orden para evitar escrituras concurrentes desde la interfaz. El mes seleccionado se conserva al modificar movimientos. El formulario espera la confirmación de persistencia antes de cerrarse.

## Instalación y ejecución

```bash
git clone https://github.com/MiguelArbelaez0/FLUTTER_FINANCE_CLEAN_BLOC.git
cd FLUTTER_FINANCE_CLEAN_BLOC
flutter pub get
flutter run
```

Para navegador: `flutter run -d chrome`. Android requiere SDK, licencias y una versión de Java compatible con Gradle. Los archivos de plataforma existen para Android, iOS, web, Windows, macOS y Linux; su presencia no garantiza que todas las plataformas estén verificadas.

## Importes y persistencia

Los nuevos importes deben ser positivos, admitir como máximo dos decimales y no superar 1.000.000.000 por movimiento. Se acepta coma o punto decimal, sin separadores de miles ni notación científica. Los cálculos suman centavos enteros y la interfaz muestra decimales.

Hive utiliza la caja `transactions_box` y conserva el formato de mapas existente. Los registros antiguos con importes enteros también se leen. Si un registro antiguo tiene más de dos decimales, se conserva su valor almacenado y se redondea a centavos para el balance; editarlo requiere un importe de hasta dos decimales. No se realiza migración ni borrado automático.

Si un registro es inválido, la carga falla de forma visible y conserva los datos para su recuperación. Los identificadores duplicados se rechazan para evitar sobrescrituras involuntarias.

La información permanece en el almacenamiento local de la aplicación; en web depende del navegador y del origen. Borrar datos del navegador o desinstalar la aplicación puede eliminarla. No hay sincronización, exportación, respaldo automático, autenticación ni cifrado configurado.

## Pruebas y validación

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
flutter build apk --debug
```

Las 10 pruebas verificadas cubren precisión monetaria, entradas inválidas, balance vacío y negativo, CRUD real con Hive, reapertura de almacenamiento, compatibilidad de registros, datos corruptos, filtros por año y mes, errores y orden de eventos BLoC, estado vacío y guardado desde el formulario. `flutter analyze` finaliza sin incidencias y la compilación web está verificada.

La compilación `flutter build apk --debug` también está verificada con Eclipse Temurin **17.0.20.1**, Gradle **8.14**, Android Gradle Plugin **8.11.1** y Kotlin **2.2.20**. El APK se genera en `build/app/outputs/flutter-apk/app-debug.apk`; se comprobaron su integridad ZIP, alineación y firma v2 con certificado Android Debug. Es una compilación de desarrollo, sin validación de ejecución en Android.

Para esta compilación se reutilizó un JDK 17 portátil, sin copiarlo ni cambiar la configuración global: `JAVA_HOME` y `PATH` se establecieron solo en el proceso, y Flutter recibió `jdk-dir` mediante un archivo `.flutter_settings` en un `APPDATA` aislado bajo `.dart_tool`. Cambiar únicamente `JAVA_HOME` puede no bastar si Flutter selecciona el Java de Android Studio.

## Limitaciones

- Una sola unidad monetaria, mostrada con formato colombiano; no hay conversión de divisas.
- La persistencia usa el esquema numérico existente; la aritmética del balance se realiza en centavos.
- No hay recuperación automática de archivos Hive dañados ni administración de categorías.
- No hay pruebas en dispositivos físicos ni compilaciones verificadas de iOS, macOS, Linux o Windows.
- El Java 25 predeterminado del entorno es incompatible con Gradle 8.14; la compilación comprobada utiliza JDK 17 mediante ajustes temporales del proceso.
- Faltan Android `cmdline-tools`; aunque el SDK instalado permite generar el APK, `flutter doctor` no puede verificar el estado completo de licencias. No se instalaron herramientas ni se aceptaron licencias durante esta validación.
- Flutter advierte que las versiones actuales de Gradle, Android Gradle Plugin y Kotlin dejarán de estar admitidas en una versión futura; su actualización debe validarse por separado.
- La configuración Android de publicación conserva identificador de ejemplo y firma de depuración; debe prepararse antes de distribuir una versión de producción.

## Autor

**Miguel Arbeláez Vallejo**

Flutter & Dart · Full-Stack · Backend · AI/Data

- [GitHub](https://github.com/MiguelArbelaez0)
- [LinkedIn](https://www.linkedin.com/in/miguel-arbelaez-v-57719542b/)
