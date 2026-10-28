#!/usr/bin/env bash
# Instala skill, agentes y regla de routing en ~/.claude sin pisar lo existente.
set -euo pipefail

aqui="$(cd "$(dirname "$0")" && pwd)"
destino="${CLAUDE_HOME:-$HOME/.claude}"
fecha="$(date +%Y%m%d)"
marca="<!-- model-routing -->"

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

# Regla en CLAUDE.md global, una sola vez
archivo="$destino/CLAUDE.md"
touch "$archivo"
if grep -q "$marca" "$archivo"; then
  echo "CLAUDE.md: la regla ya estaba"
else
  cp "$archivo" "$archivo.bak-$fecha"
  { printf '\n%s\n' "$marca"; cat "$aqui/snippets/CLAUDE-routing.md"; } >> "$archivo"
  echo "CLAUDE.md: regla agregada"
fi

echo "Listo. Revisa los modelos con /tasks."
