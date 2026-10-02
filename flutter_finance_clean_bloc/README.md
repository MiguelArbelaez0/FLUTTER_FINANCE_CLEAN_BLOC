# FLUTTER_FINANCE_CLEAN_BLOC

## Descripción

Aplicación Flutter sencilla para registrar y consultar ingresos y gastos personales. Los movimientos se guardan localmente en el dispositivo.

## Características

- Crear, editar y eliminar transacciones.
- Consultar transacciones agrupadas por el mes seleccionado.
- Ver ingresos, gastos y balance del mes en el panel principal.
- Guardar los datos localmente con Hive.
- Validación básica del formulario: el monto debe ser mayor que cero y la descripción debe tener al menos tres caracteres. El formulario no muestra mensajes de error para estos casos.

## Arquitectura

El código está organizado por capas y por funcionalidad dentro de `lib/features/finance`:

- `domain`: entidades, contrato del repositorio y casos de uso.
- `data`: modelo, fuente de datos local y repositorio.
- `presentation`: BLoC, páginas y widgets.
- `lib/core`: utilidades, errores y servicios comunes.
- `lib/app`: configuración y composición de la aplicación.

`FinanceBloc` carga, agrega, actualiza y elimina transacciones, y cambia el mes seleccionado. El panel calcula y presenta los totales del mes. El archivo `domain/use cases/calculate_balance.dart` está vacío y no se utiliza actualmente.

## Tecnologías

- Flutter y Dart
- `flutter_bloc` para el estado
- Hive y `hive_flutter` para persistencia local
- `intl` para formato de fechas
- Material 3 mediante el tema de Flutter

## Estructura del proyecto

```text
lib/
├── app/
├── core/
│   ├── errors/
│   ├── use cases/
│   └── utils/
└── features/
    └── finance/
        ├── data/
        │   ├── data sources/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── use cases/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/
```

## Persistencia local

La aplicación inicializa Hive al arrancar y utiliza la caja `transactions_box`. La fuente de datos convierte los registros almacenados al modelo de transacción y los entrega al repositorio.

## Testing

Actualmente hay una prueba unitaria en `test/finance_balance_test.dart` que comprueba operaciones aritméticas de balance. No hay pruebas de BLoC, widgets ni integración.

## Instalación

Desde la raíz del repositorio clonado:

```sh
cd flutter_finance_clean_bloc
flutter pub get
```

## Ejecución

```sh
flutter run
```

## Tests

```sh
flutter test
```

## Futuras mejoras

- Implementar el caso de uso de cálculo de balance y trasladar la lógica fuera de la página.
- Añadir pruebas para el BLoC, formularios, widgets y persistencia.
- Mostrar mensajes de validación claros en el formulario.
- Añadir categorías configurables y filtros adicionales.
