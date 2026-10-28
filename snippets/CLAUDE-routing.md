## Routing
1. Para toda tarea de código, llama primero al agente triage.
2. Delega al agente de la ruta que indique: quick, build o deep. Pásale la tarea completa y el JSON de triage. Nunca pases el parámetro model.
3. Luego llama al verifier con el riesgo y los chequeos de triage.
4. Si el verifier dice FAIL, reintenta una vez, un paso más arriba:
   - se saltó un archivo o no corrió las pruebas: más esfuerzo (quick -> build)
   - tenía el contexto y se equivocó: modelo mayor (build -> deep -> escalate)
5. Tras cualquier escalada, pide a triage que guarde una línea en su memoria:
   "<patrón de tarea> -> <ruta que funcionó>".
6. Las tareas triviales y de conversación se resuelven directo, sin routing.
