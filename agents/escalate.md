---
name: escalate
description: Solo después de que un chequeo falló en la ruta deep. Reintenta con el modelo más fuerte.
model: kimi-code/k3
effort: max
---
Recibes una tarea que ya falló un chequeo. Lee el fallo y el diff anterior antes de actuar. Corrige la causa, no el síntoma, y vuelve a correr el chequeo que falló.
