# model-routing-skill

Skill, subagentes y regla de CLAUDE.md para enrutar tareas entre modelos Claude (Haiku, Sonnet, Opus) con los mecanismos nativos de Claude Code. Sin proxies ni routers externos.

Basado en el Model Routing Playbook de @donimas (revisado el 5 de octubre de 2026). Aquí está la versión para Claude Code, traducida y empaquetada.

## Qué incluye

| Ruta | Contenido |
|---|---|
| `skills/model-routing/SKILL.md` | Las reglas, la escalada y el mapa de agentes |
| `agents/` | `triage`, `quick`, `build`, `deep`, `escalate` y `verifier`, cada uno con su modelo y esfuerzo |
| `snippets/CLAUDE-routing.md` | La regla de delegación para tu `CLAUDE.md` global |
| `install.sh` | Instala todo en `~/.claude` con respaldo |

## Instalar

```bash
./install.sh
```

El script:

- copia los agentes a `~/.claude/agents/` y respalda como `.bak-AAAAMMDD` cualquiera con el mismo nombre;
- copia la skill a `~/.claude/skills/model-routing/`;
- agrega la regla a `~/.claude/CLAUDE.md` una sola vez (marca `<!-- model-routing -->`), con respaldo.

Con otra carpeta de configuración: `CLAUDE_HOME=/ruta ./install.sh`.

## Probar

| Comando | Qué deberías ver |
|---|---|
| `/model sonnet` | Sesión principal en Sonnet, que actúa de router |
| `/tasks` tras delegar | `triage`, `quick` y `verifier` en sonnet; `build` y `deep` en opus; `escalate` en fable |
| Tarea trivial | Se resuelve directo, sin subagentes |
| Tarea con migración | `triage` devuelve `deep` y trabaja `deep` en opus |
| Un chequeo que falla | Un solo reintento un paso más arriba, y una línea nueva en la memoria de `triage` |

## Notas

- No definas `CLAUDE_CODE_EFFORT_LEVEL`: pisa el esfuerzo propio de cada subagente.
- `effort:` en el frontmatter y el alias `fable` salen del playbook. Si tu versión no los reconoce, ajusta el agente.
- El playbook también propone un hook `Stop` que corre los tests antes de dar la tarea por terminada. No se incluye porque depende de tu comando de pruebas.
