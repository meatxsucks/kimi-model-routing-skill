#!/usr/bin/env bash
# Instala skill, agentes y regla de routing en ~/.kimi-code sin pisar lo existente.
set -euo pipefail

aqui="$(cd "$(dirname "$0")" && pwd)"
destino="${KIMI_CODE_HOME:-$HOME/.kimi-code}"
fecha="$(date +%Y%m%d)"
marca="<!-- kimi-model-routing -->"

mkdir -p "$destino/agents" "$destino/skills"

# Agentes: si ya existe uno con el mismo nombre se respalda y se reemplaza
for f in "$aqui"/agents/*.md; do
  nombre="$(basename "$f")"
  if [ -f "$destino/agents/$nombre" ]; then
    cp "$destino/agents/$nombre" "$destino/agents/$nombre.bak-$fecha"
  fi
  cp "$f" "$destino/agents/$nombre"
  echo "agente: $nombre"
done

# Skill
rm -rf "$destino/skills/model-routing"
cp -R "$aqui/skills/model-routing" "$destino/skills/model-routing"
echo "skill: model-routing"

# Regla en AGENTS.md global, una sola vez
archivo="$destino/AGENTS.md"
touch "$archivo"
if grep -q "$marca" "$archivo"; then
  echo "AGENTS.md: la regla ya estaba"
else
  cp "$archivo" "$archivo.bak-$fecha"
  { printf '\n%s\n' "$marca"; cat "$aqui/snippets/KIMI-routing.md"; } >> "$archivo"
  echo "AGENTS.md: regla agregada"
fi

echo "Listo. Revisa los agentes con ls $destino/agents."
