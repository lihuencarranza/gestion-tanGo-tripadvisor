# TanGo - Sistema de Gestión de Hoteles, Restaurantes y Actividades

Aplicación web completa para la gestión y visualización de hoteles, restaurantes y actividades turísticas, desarrollada con Spring Boot (backend) y Next.js (frontend).

<img width="2852" height="1318" alt="image" src="https://github.com/user-attachments/assets/5e15d5af-fbd2-4116-b0aa-84e2a406969c" />


## Contenidos

- [Requisitos](#requisitos)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Configuración Inicial](#configuración-inicial)
- [Ejecución con Docker](#ejecución-con-docker)
- [Ejecución Manual](#ejecución-manual)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Variables de Entorno](#variables-de-entorno)
- [Solución de Problemas](#solución-de-problemas)

## Requisitos

### Para Ejecución con Docker (Recomendado)

- **Docker Desktop** ≥ 20.10
- **Docker Compose** ≥ 2.0
- **Git** (para clonar el repositorio)

### Para Ejecución Manual

#### Backend
- **Java 21** o superior
- **Maven 3.9+** (o usar el wrapper `mvnw` incluido)
- **MongoDB** 8.0+ (local o MongoDB Atlas)

#### Frontend
- **Node.js** ≥ 18.18.0 (recomendado 20.x LTS)
- **npm** o **pnpm** (recomendado pnpm)

## Tecnologías Utilizadas

### Backend
- **Spring Boot 3.5.6** - Framework Java para APIs REST
- **Spring Data MongoDB** - Integración con MongoDB
- **MongoDB Driver 5.6.1** - Cliente MongoDB
- **Lombok** - Reducción de código boilerplate
- **Maven** - Gestión de dependencias y build
- **Java 21** - Lenguaje de programación

### Frontend
- **Next.js 15.5.9** - Framework React con SSR
- **React 18.2.0** - Biblioteca UI
- **TypeScript** - Tipado estático
- **Tailwind CSS 4.1.9** - Framework CSS
- **Radix UI** - Componentes UI accesibles
- **Shadcn/ui** - Componentes UI
- **Supabase** - Almacenamiento de imágenes
- **Google Maps API** - Mapas y ubicaciones
- **AI SDK** - Integración con modelos de IA (Google Gemini)

### Base de Datos
- **MongoDB 8.0** - Base de datos NoSQL


## ⚙️ Configuración Inicial

### 1. Clonar el Repositorio

```bash
git clone <url-del-repositorio>
cd gestion-tripadvisor
```

### 2. Inicializar Submódulos Git

El proyecto utiliza submódulos Git para el código fuente:

```bash
git submodule update --init --recursive
```

Esto inicializará:
- `gestion-g6-back` - Código del backend
- `gestion-g6-front` - Código del frontend


## Ejecución con Docker


### Opción 1: Usar Script de Ayuda (Recomendado)

#### Windows PowerShell
```powershell
.\docker-start.ps1
```

#### Linux/Mac
```bash
chmod +x docker-start.sh
./docker-start.sh
```

### Opción 2: Comandos Docker Compose Manuales

#### Levantar Todos los Servicios

```bash
# Construir y levantar en modo producción
docker-compose up -d --build

# O solo levantar (si ya están construidas las imágenes)
docker-compose up -d
```

#### Modo Desarrollo (con hot reload)

```bash
docker-compose -f docker-compose.dev.yml up -d --build
```

### Verificar que los Servicios Estén Corriendo

```bash
docker-compose ps
```

Deberías ver tres servicios con estado "Up" o "Healthy":
- `gestion-mongodb` (puerto 27017)
- `gestion-backend` (puerto 8080)
- `gestion-frontend` (puerto 3000)

### URLs Disponibles

Una vez levantados los servicios:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **MongoDB**: localhost:27017

### Comandos Útiles de Docker

```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f frontend
docker-compose logs -f backend
docker-compose logs -f mongodb

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (⚠️ elimina datos de MongoDB)
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart frontend

# Reconstruir imágenes después de cambios
docker-compose build
docker-compose up -d

# Ver uso de recursos
docker stats
```

### Cargar Datos Iniciales

Para poblar la base de datos con datos de ejemplo:

```bash
# Opción 1: Desde el contenedor del backend
docker-compose exec backend node load-database.js

# Opción 2: Desde tu máquina local (si tienes Node.js instalado)
cd gestion-g6-back
node load-database.js
```

## 📁 Estructura del Proyecto

```
gestion-tripadvisor/
├── gestion-g6-back/              # Backend Spring Boot (submódulo)
│   ├── src/
│   │   └── main/
│   │       ├── java/             # Código fuente Java
│   │       └── resources/
│   │           └── application.properties
│   ├── pom.xml                   # Dependencias Maven
│   ├── Dockerfile                # Imagen Docker del backend
│   ├── load-database.js         # Script para cargar datos
│   └── env-template             # Plantilla de variables de entorno
│
├── gestion-g6-front/            # Frontend Next.js (submódulo)
│   ├── app/                     # Rutas y páginas Next.js
│   ├── components/              # Componentes React
│   ├── api/                     # Cliente API
│   ├── package.json             # Dependencias npm
│   ├── Dockerfile               # Imagen Docker del frontend
│   ├── Dockerfile.dev           # Imagen Docker para desarrollo
│   └── env-template             # Plantilla de variables de entorno
│
├── docker-compose.yml           # Configuración Docker para producción
├── docker-compose.dev.yml       # Configuración Docker para desarrollo
├── docker-start.ps1             # Script PowerShell para iniciar Docker
├── docker-start.sh               # Script Bash para iniciar Docker
└── README.md                     # Este archivo
```

## 🔐 Variables de Entorno

### Backend (`gestion-g6-back/.env`)

```env
CLOUD_MONGO_USER=<tu_usuario_mongodb>
CLOUD_MONGO_PASSWORD=<tu_contraseña_mongodb>
CLOUD_MONGO_LINK=mongodb+srv://$CLOUD_MONGO_USER:$CLOUD_MONGO_PASSWORD@gestion-g6.w0a2iw7.mongodb.net/?appName=gestion-g6
```

**Para MongoDB local:**
```env
CLOUD_MONGO_LINK=mongodb://localhost:27017/gestion-g6
```

### Frontend (`gestion-g6-front/.env.local`)

```env
NEXT_PUBLIC_SUPABASE_URL=https://ucntmhnssxrrmspecams.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<tu_clave_anon>
NEXT_PUBLIC_SUPABASE_BUCKET_NAME=tango-images
GOOGLE_GENERATIVE_AI_API_KEY=<tu_api_key_google>
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=<tu_api_key_maps>
NEXT_PUBLIC_MAP_ID=<tu_map_id>
NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
```

**Nota**: Las variables `NEXT_PUBLIC_*` están disponibles tanto en el cliente como en el servidor. Para Docker, el servidor usa `API_BASE_URL=http://backend:8080` automáticamente.

## 🔍 Endpoints Principales del Backend

- `GET /ping` - Verificación de salud del servicio
- `GET /hotels` - Listar todos los hoteles
- `GET /hotel/{id}` - Obtener hotel por ID
- `POST /hotel` - Crear nuevo hotel
- `PUT /hotel/{id}` - Actualizar hotel
- `GET /restaurants` - Listar todos los restaurantes
- `GET /restaurant/{id}` - Obtener restaurante por ID
- `POST /restaurant` - Crear nuevo restaurante
- `GET /activities` - Listar todas las actividades
- `GET /activity/{id}` - Obtener actividad por ID
- `POST /activity` - Crear nueva actividad
- `GET /posts/owner/{ownerId}` - Obtener publicaciones por propietario
- `GET /posts/full` - Obtener todos los posts completos (para IA)


## 📝 Notas Adicionales

- El proyecto usa **submódulos Git** para `gestion-g6-back` y `gestion-g6-front`
- Las imágenes se almacenan en **Supabase Storage** (bucket: `tango-images`)
- El proyecto utiliza **Google Maps API** para mostrar ubicaciones
- Para desarrollo activo, usa `docker-compose.dev.yml` que tiene hot reload habilitado
- El backend usa **MongoDB** como base de datos principal
- El frontend usa **Next.js** con modo standalone para Docker

## 🤝 Contribuir

1. Asegúrate de que los submódulos estén inicializados
2. Trabaja en los directorios `gestion-g6-back` o `gestion-g6-front`
3. Prueba tus cambios con Docker antes de hacer commit
4. Actualiza la documentación si es necesario

## 📄 Licencia

Ver archivo LICENSE en cada submódulo del proyecto.
