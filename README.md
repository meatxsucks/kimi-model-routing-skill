# kimi-model-routing-skill

Skill, subagentes y regla de AGENTS.md para enrutar tareas por **esfuerzo** en Kimi Code. Fork de [model-routing-skill](https://github.com/meatxsucks/model-routing-skill) adaptado para Kimi.

## Diferencia clave con Claude

En Claude Code el routing cambia de modelo (`haiku`, `sonnet`, `opus`, `fable`). En Kimi Code todos los agentes usan el mismo modelo base (`kimi-code/k3`) y se diferencian por el **esfuerzo** (`low`, `high`, `max`).

## Qué incluye

| Ruta | Contenido |
|---|---|
| `skills/model-routing/SKILL.md` | Las reglas, la escalada y el mapa de agentes |
| `agents/` | `triage`, `quick`, `build`, `deep`, `escalate` y `verifier`, cada uno con modelo y esfuerzo |
| `snippets/KIMI-routing.md` | La regla de delegación para tu `AGENTS.md` global |
| `install.sh` | Instala todo en `~/.kimi-code` con respaldo |

## Instalar

```bash
./install.sh
```

El script:

- copia los agentes a `~/.kimi-code/agents/` y respalda como `.bak-AAAAMMDD` cualquiera con el mismo nombre;
- copia la skill a `~/.kimi-code/skills/model-routing/`;
- agrega la regla a `~/.kimi-code/AGENTS.md` una sola vez (marca `<!-- kimi-model-routing -->`), con respaldo.

Con otra carpeta de configuración: `KIMI_CODE_HOME=/ruta ./install.sh`.

## Probar

| Escenario | Qué deberías ver |
|---|---|
| Tarea trivial | Se resuelve directo, sin subagentes |
| Tarea pequeña | `triage` -> `quick` con `effort: low` |
| Feature normal | `triage` -> `build` con `effort: high` |
| Migración/riesgo | `triage` -> `deep` con `effort: max` |
| Chequeo fallido | Un solo reintento un escalón más arriba |

## Notas

- No se pasa `model` ni `effort` al invocar `Agent`: cada agente los declara en su frontmatter.
- `effort:` en el frontmatter debe ser `low`, `high` o `max` para los modelos Kimi.
- Ningún router verifica el resultado por ti. Mantén tu propio chequeo en el lazo.
