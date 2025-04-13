#!/bin/bash
set -e

# Usa valores por defecto si no vienen definidos
RUNNER_VERSION=${RUNNER_VERSION:-2.323.0}
RUNNER_ARCH="actions-runner-linux-x64-${RUNNER_VERSION}"
RUNNER_TGZ="${RUNNER_ARCH}.tar.gz"
RUNNER_DIR="/home/${RUNNER_USER}/actions-runner"

# Crear carpeta y moverse
mkdir -p "$RUNNER_DIR"
sudo chown -R ${RUNNER_USER}:${RUNNER_USER} "$RUNNER_DIR"
cd "$RUNNER_DIR"

# Descargar el runner solo si no existe
if [ ! -f "./config.sh" ]; then
  echo "Descargando runner v$RUNNER_VERSION..."
  curl -o "$RUNNER_TGZ" -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TGZ}"
  tar xzf "$RUNNER_TGZ"
  rm "$RUNNER_TGZ"

  # Instalar dependencias de .NET necesarias
  echo "Instalando dependencias de .NET para el runner..."
  sudo ./bin/installdependencies.sh || true

  # Configurar el runner solo si no está configurado
  echo "Configurando el runner..."
  ./config.sh --unattended \
    --url "$RUNNER_REPO" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --work _work \
    --replace
else
  echo "El runner ya está configurado."
fi

# Después de descomprimir el runner
chown -R "${RUNNER_USER}:${RUNNER_USER}" "$RUNNER_DIR"

# Función de limpieza
cleanup() {
  echo "Eliminando runner..."
  ./config.sh remove --unattended --token "$RUNNER_TOKEN"
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Iniciar el runner
./run.sh