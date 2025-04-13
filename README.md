# 🐳 GitHub Self-Hosted Runner en Docker

Este proyecto te permite levantar un **runner auto-hospedado de GitHub Actions** usando Docker, ideal para pruebas locales o para integrar tu propio entorno de ejecución en CI/CD sin depender de los runners hospedados por GitHub.

---

## 🚀 Características

- Basado en **Ubuntu 20.04**
- Totalmente configurable vía variables de entorno
- Compatible con contenedores gracias al volumen de Docker socket
- Facilita pruebas locales de flujos de CI
- Compatible con múltiples repositorios

---

## 📁 Estructura del Proyecto

- `Dockerfile`: define la imagen base del runner.
- `entrypoint.sh`: configura e inicia el runner.
- `docker-compose.yml`: orquesta la ejecución.
- `.env.example`: plantilla de configuración para tus variables de entorno.

---

## ⚙️ Requisitos

- Docker
- Docker Compose
- Un repositorio de GitHub donde quieras registrar el runner
- Un token de registro generado desde tu repositorio (`Settings > Actions > Runners > New self-hosted runner`)

---

## 🛠️ Configuración

1. Clona este repositorio:

   ```bash
   git clone https://github.com/tu_usuario/github-selfhosted-runner.git
   cd github-selfhosted-runner
   ```

2. Copia el archivo de variables de entorno:

   ```bash
   cp .env.example .env
   ```

3. Edita el archivo `.env` con tus datos:

   ```env
   RUNNER_NAME=mi-runner
   RUNNER_REPO=https://github.com/tu_usuario/tu_repo
   RUNNER_TOKEN=tu_token_generado
   RUNNER_VERSION=2.323.0
   RUNNER_USER=runneruser
   ```

---

## ▶️ Uso

Levanta el contenedor con Docker Compose:

```bash
docker compose up -d --build
```

> El runner se descargará, configurará y quedará a la espera de jobs desde tu repositorio GitHub.

---

## 🧼 Detener y Limpiar

Para detener el contenedor y eliminar el runner del repositorio:

```bash
docker compose down
```

El script `entrypoint.sh` se encargará de limpiar el registro del runner usando el token.

---

## 📦 Volúmenes

- `runner-data`: Guarda la configuración del runner y su estado para mantener persistencia entre reinicios.
- `/var/run/docker.sock`: Permite al runner ejecutar otros contenedores si es necesario.

---

## 📌 Notas

- El contenedor se ejecuta como un usuario no root por seguridad.
- Puedes personalizar la versión del runner modificando `RUNNER_VERSION` en `.env`.

---

## 🧪 Casos de uso

- Ejecutar pipelines localmente sin depender de GitHub-hosted runners
- Integrar runners personalizados con herramientas específicas
- Ejecutar jobs de GitHub Actions que requieren acceso al sistema anfitrión o a Docker

---

## 🛡️ Seguridad

Asegúrate de proteger tu archivo `.env`, ya que contiene el token de registro del runner.

---

## 📄 Licencia

MIT License

---

## 🛠️ Uso en Workflows de GitHub Actions

Una vez que el runner auto-hospedado esté activo y conectado a tu repositorio, podrás utilizarlo en tus workflows de GitHub Actions.

Solo necesitas especificar el parámetro `runs-on: self-hosted` en tu archivo de workflow:

```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      # Agrega aquí los pasos de tu workflow
```

> El parámetro `runs-on: self-hosted` le indica a GitHub Actions que este job debe ejecutarse usando uno de tus runners auto-hospedados, en lugar de los proporcionados por GitHub.


```plaintext
# TODO
- [x] Crear un README bonito :p
- [ ] Commpartir con alguien para probar.
- [x] Probar el runner en un repositorio de prueba.
```

