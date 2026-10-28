---
name: model-routing
description: Reglas de routing por esfuerzo para Kimi Code. Úsala cuando haya que decidir con qué esfuerzo hacer una tarea, cuándo delegar a un subagente, cuándo escalar tras un fallo, o cuando pidan instalar o revisar el setup de routing.
---

# Model routing

Basada en el Model Routing Playbook de @donimas, adaptada para Kimi Code. En Kimi Code el routing no cambia de modelo: todos los agentes usan el mismo modelo base y se diferencian por el **esfuerzo** (`low`, `high`, `max`).

## Las 5 reglas

1. **Esfuerzo antes que escalada.** Casi ninguna tarea necesita `max` al principio. Subir el esfuerzo es barato; cambiar la arquitectura de la solución a mitad de sesión es caro.
2. **No uses el esfuerzo tope por defecto.** Un escalón por debajo resuelve casi lo mismo. El tope queda para escalar.
3. **Rutas por tipo de tarea y riesgo:**
   - `quick`: pequeña y bien especificada, uno o dos archivos.
   - `build`: feature o corrección normal.
   - `deep`: arquitectura, migraciones, auth, pagos, datos o algo poco claro.
4. **Verifica con código** (tests, tipos, lint). Si falla, un solo reintento un paso más arriba.
5. **Anota cada fallo** como una línea: `<patrón de tarea> -> <ruta que funcionó>`.

## Escalada

- Si se saltó un archivo o no corrió los chequeos: sube el **esfuerzo** del mismo agente (`low -> high -> max`).
- Si tenía todo el contexto y aun así falló: sube de **ruta** (`quick -> build -> deep -> escalate`).
- Un reintento. Si vuelve a fallar, para y pregunta.

## Mapa de agentes

| Agente | Modelo | Esfuerzo | Uso |
|---|---|---|---|
| `triage` | kimi-code/k3 | low | Clasifica la tarea en ruta, riesgo y chequeos. Guarda memoria de fallos. |
| `quick` | kimi-code/k3 | low | Cambios pequeños y bien especificados. |
| `build` | kimi-code/k3 | high | Features y correcciones normales. |
| `deep` | kimi-code/k3 | max | Trabajo riesgoso o poco claro. |
| `escalate` | kimi-code/k3 | max | Solo tras un chequeo fallido. |
| `verifier` | kimi-code/k3 | high | Corre los chequeos y responde PASS o FAIL con evidencia. No edita. |

En Kimi Code no se pasa `model` al invocar `Agent`: cada agente declara su `model` y `effort` en el frontmatter.

## Flujo

1. `triage` devuelve `{"route", "risk", "checks"}`.
2. Se delega al agente de esa ruta, sin pasar parámetro `model` ni `effort`.
3. `verifier` corre los chequeos que triage indicó.
4. FAIL: escalada como arriba. Luego triage guarda la lección.

## Instalar o revisar

- Instalar: `./install.sh` desde la raíz del repo. Respalda lo que ya exista y no pisa agentes con el mismo nombre.
- Revisar qué agentes hay disponibles: `ls ~/.kimi-code/agents`.
- Revisar cada pocas semanas los fallos anotados y convertirlos en reglas.

## Límites

- Aplica a sesiones con modelos Kimi. Si la sesión usa otro proveedor, los esfuerzos pueden no tener efecto.
- `effort:` en el frontmatter debe ser uno de los soportados por el modelo (`low`, `high`, `max` para los modelos Kimi).
- Ningún router verifica el resultado por ti. Mantén tu propio chequeo en el lazo.
