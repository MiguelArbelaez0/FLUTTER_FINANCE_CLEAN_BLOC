# Flutter Finance Clean BLoC

Aplicación móvil de finanzas personales desarrollada con Flutter y Dart, utilizando BLoC, principios de Clean Architecture y persistencia local con Hive.

## 📱 Descripción general

Flutter Finance Clean BLoC es una aplicación de gestión financiera local para registrar, organizar y calcular transacciones personales.

El proyecto demuestra cómo separar presentación, dominio y datos mientras BLoC gestiona el estado y Hive mantiene la información de forma local.

## 🚀 Funcionalidades

- Crear transacciones financieras.
- Consultar transacciones.
- Actualizar información.
- Eliminar transacciones.
- Calcular totales mensuales.
- Calcular el saldo.
- Persistir información localmente.
- Gestión reactiva con BLoC.
- Separación de responsabilidades.
- Principios de Clean Architecture.

## 🏗️ Arquitectura

```text
Presentación
     ↓
BLoC
     ↓
Casos de uso
     ↓
Repositorio
     ↓
Fuente de datos local
     ↓
Hive
```

La arquitectura separa la interfaz y la gestión de estado de la lógica de negocio y la persistencia.

## 🧩 Tecnologías

| Tecnología | Uso |
|---|---|
| Flutter | Desarrollo de la aplicación |
| Dart | Lenguaje de programación |
| flutter_bloc | Gestión de estado |
| BLoC | Estado de la aplicación |
| Hive | Persistencia local |
| Clean Architecture | Organización de la aplicación |
| Repository Pattern | Abstracción de datos |

## 💰 Gestión de transacciones

La aplicación permite crear, consultar, actualizar y eliminar transacciones desde la interfaz.

Cada transacción participa en los cálculos financieros utilizados para mostrar la información actual y mensual.

## 📊 Cálculos financieros

Incluye:

- Total de ingresos.
- Total de gastos.
- Totales mensuales.
- Saldo actual.

Los cálculos se realizan sobre las transacciones almacenadas localmente.

## 💾 Persistencia local

Hive permite conservar las transacciones entre sesiones sin requerir un servidor remoto para el flujo principal.

## ⚡ Gestión de estado

BLoC administra el estado y coordina los cambios entre presentación, dominio y datos, manteniendo las operaciones separadas de la interfaz.

## 📂 Estructura

```text
lib/
├── core/
├── data/
├── domain/
└── presentation/
```

### Presentación
Pantallas, widgets y gestión del estado con BLoC.

### Dominio
Entidades, contratos de repositorio y casos de uso.

### Datos
Acceso local, modelos e implementaciones de repositorios.

### Core
Funcionalidades compartidas y utilidades.

## ⚙️ Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/MiguelArbelaez0/FLUTTER_FINANCE_CLEAN_BLOC.git
cd FLUTTER_FINANCE_CLEAN_BLOC
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar

```bash
flutter run
```

## 🎯 Qué demuestra este proyecto

- Flutter y Dart.
- Gestión de estado con BLoC.
- Principios de Clean Architecture.
- Repository Pattern.
- Casos de uso.
- Persistencia local.
- Hive.
- Operaciones CRUD.
- Cálculos financieros.
- Separación de responsabilidades.

## 🧪 Pruebas

El proyecto incluye pruebas de funcionalidades principales.

La separación entre presentación, dominio y datos facilita probar las capas de forma independiente.

## 📌 Estado del proyecto

**Proyecto de portafolio terminado.**

Desarrollado para demostrar arquitectura de aplicaciones Flutter, gestión de estado con BLoC, persistencia local con Hive, operaciones CRUD y cálculos financieros.

## 👨‍💻 Autor

**Miguel Arbeláez Vallejo**

Flutter & Dart · Full-Stack · Backend · AI/Data
