---
name: model-routing
description: Reglas de routing de modelos y esfuerzo para Claude Code (Haiku, Sonnet, Opus). Úsala cuando haya que decidir con qué modelo o esfuerzo hacer una tarea, cuándo delegar a un subagente, cuándo escalar tras un fallo, o cuando pidan instalar o revisar el setup de routing.
---

# Model routing

Basada en el Model Routing Playbook de @donimas (revisado el 5 de octubre de 2026). Esta skill resume las reglas y apunta a los archivos del repo que las instalan.

## Las 5 reglas

1. **Esfuerzo antes que modelo.** Casi ninguna tarea necesita `high`. Cambiar el esfuerzo es barato; cambiar de modelo a mitad de sesión reconstruye la caché.
2. **No uses el modelo tope por defecto.** Un escalón por debajo resuelve casi lo mismo a una fracción del precio. El tope queda para escalar.
3. **Rutas por tipo de tarea y riesgo:**
   - `quick`: pequeña y bien especificada, uno o dos archivos.
   - `build`: feature o corrección normal.
   - `deep`: arquitectura, migraciones, auth, pagos, datos o algo poco claro.
4. **Verifica con código** (tests, tipos, lint). Si falla, un solo reintento un paso más arriba.
5. **Anota cada fallo** como una línea: `<patrón de tarea> -> <ruta que funcionó>`.

## Escalada

- Si se saltó un archivo o no corrió los chequeos: sube el **esfuerzo** del mismo agente.
- Si tenía todo el contexto y aun así falló: sube de **modelo** (`quick -> build -> deep -> escalate`).
- Un reintento. Si vuelve a fallar, para y pregunta.

## Mapa de agentes

| Agente | Modelo | Esfuerzo | Uso |
|---|---|---|---|
| `triage` | sonnet | low | Clasifica la tarea en ruta, riesgo y chequeos. Guarda memoria de fallos. |
| `quick` | sonnet | low | Cambios pequeños y bien especificados. |
| `build` | opus | medium | Features y correcciones normales. |
| `deep` | opus | xhigh | Trabajo riesgoso o poco claro. |
| `escalate` | fable | high | Solo tras un chequeo fallido. |
| `verifier` | sonnet | medium | Corre los chequeos y responde PASS o FAIL con evidencia. No edita. |

## Flujo

1. `triage` devuelve `{"route", "risk", "checks"}`.
2. Se delega al agente de esa ruta, sin pasar parámetro `model`.
3. `verifier` corre los chequeos que triage indicó.
4. FAIL: escalada como arriba. Luego triage guarda la lección.

## Instalar o revisar

- Instalar: `./install.sh` desde la raíz del repo. Respalda lo que ya exista y no pisa agentes con el mismo nombre.
- Revisar qué modelo corre cada subagente: `/tasks`.
- Revisar cada pocas semanas los fallos anotados y convertirlos en reglas.

## Límites

- Aplica a sesiones con modelos Claude. Con proveedores externos los alias `opus`, `sonnet` y `haiku` no apuntan a modelos Claude.
- `effort:` en el frontmatter y el alias `fable` vienen del playbook. Si tu versión de Claude Code no los reconoce, quita la línea o cambia el alias en el agente.
- Ningún router verifica el resultado por ti. Mantén tu propio chequeo en el lazo.
