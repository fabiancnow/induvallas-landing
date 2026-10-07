# Experiencia de Usuario y Filtro de Captación - MOFU (Semana 2)
**Marca:** Induvallas  
**Objetivo:** Landing Page de alta conversión B2B con filtro de cualificación y captura de leads en Supabase.  
**Estado:** Código desarrollado y listo para despliegue en Vercel.  

---

## 1. Decisiones de UX y Usabilidad

La landing page fue concebida bajo los principios de diseño de alta conversión B2B para servicios *High-Ticket*, priorizando la reducción de ansiedad, la claridad de la propuesta de valor y la diferenciación contra la pauta digital.

### A. Estructura Visual y Jerarquía (Patrón en Z / F)
1. **Barra de Anuncio Superior (*Announcement Bar*):**
   * Destaca la exclusividad de espacios en el **Metro de Quito** y principales avenidas urbanas. Comunica escasez y relevancia local de inmediato.
2. **Hero Section de Alto Contraste:**
   * **Hook de diferenciación radical:** *"Domina el panorama urbano de Ecuador sin AdBlockers ni algoritmos que te oculten"*. Resuelve la frustración del comprador con la pauta digital saturada.
   * **Subtítulo con prueba numérica:** Menciona el volumen real (+50.000 impactos diarios) y las dos promesas nucleares (mapas de calor y cero riesgo de clausura).
   * **Doble CTA jerárquico:** Un botón de acción principal de alto impacto visual (*"Solicitar Circuito & Disponibilidad"*) que dirige al formulario, y un botón secundario de exploración (*"Conocer la Tecnología"*).
   * **Micro-badges de autoridad inmediata:** "+1.200 puntos", "100% permisos municipales al día" y "50M+ impactos mensuales".
3. **Simulador Visual DOOH (Preview Mockup en Hero):**
   * En lugar de una imagen estática genérica, se diseñó un mockup de pantalla digital con indicadores de telemetría en vivo (flujo vehicular de 85.000 vehículos/día, tecnología LED solar). Esto ancla la percepción de alta tecnología desde el primer segundo.
4. **Prueba Social Temprana (*Trust Bar*):**
   * Se ubica inmediatamente después del Hero para validar la marca ante el prospecto con sectores de alta exigencia (Banca, Automotriz, Retail, Telecomunicaciones) antes de presentar los detalles del servicio.
5. **Bloque de Beneficios Anti-Fricción (Resolución de los 3 Dolores Nucleares):**
   * **Tarjeta 1 (Blindaje Legal):** Ataca el miedo al desmonte municipal con garantía de licencias.
   * **Tarjeta 2 (Featured - Mapas de Calor):** Destacada con borde naranja y etiqueta de exclusividad; transforma una compra tradicional de cartelería en una decisión científica de marketing basada en datos.
   * **Tarjeta 3 (Estatus Monumental):** Apela al deseo de dominancia de marca frente a los competidores.

---

## 2. El Formulario Filtro: Justificación Estratégica de Cualificación

En el segmento B2B High-Ticket de publicidad exterior, **más leads no significa más ventas si el equipo comercial pasa el 80% de su tiempo atendiendo a personas sin presupuesto o sin autoridad de decisión**.

El formulario actúa como un **filtro MOFU (Middle of Funnel)** diseñado específicamente para separar a *curiosos* de *compradores calificados*:

| Campo del Formulario | Función Estratégica y Rationale de Negocio |
| :--- | :--- |
| **Empresa o Marca y Cargo** | **Filtro de Autoridad:** Identifica de inmediato si quien llena el formulario es un tomador de decisión (CMO, Brand Manager, Gerente General) o una consulta no calificada. |
| **Presupuesto Mensual Estimado (Filtro Nuclear)** | **Filtro Económico:** La publicidad OOH tiene costos operativos y de producción mínimos. Al ofrecer opciones desde `< $1,500` hasta `$7,000+`, el equipo comercial puede:<br>1. Descartar automáticamente o enviar propuestas automatizadas a quienes no llegan al ticket mínimo.<br>2. Priorizar llamadas de atención prioritaria (< 15 minutos) a quienes seleccionan `$3,500 - $7,000` o `$7,000+`. |
| **Ciudades y Zonas de Interés (Checkboxes)** | **Calificación de Inventario:** Permite verificar la disponibilidad de pantallas LED o vallas en tiempo real (Quito, Guayaquil, Cuenca, Metro de Quito) antes de la primera llamada, reduciendo el ciclo comercial de 5 días a solo horas. |
| **Objetivo Principal de la Campaña** | **Psicografía y Guion de Cierre:** Permite al planner comercial adaptar la presentación antes de contactar al cliente (ej. si el motivo es *"Reemplazar proveedor por falta de cumplimiento"*, el ejecutivo enfoca el pitch en puntualidad, soporte y reportes técnicos auditados). |

---

## 3. Integración Técnica con Supabase y Vercel

* **Base de Datos:** Tabla `leads` en Supabase con políticas RLS de inserción pública (anon key) y lectura administrativa.
* **Archivo de Esquema SQL:** [`landing/supabase-schema.sql`](file:///Users/fabiancampoverde/Desktop/antigravity%202026/landing/supabase-schema.sql)
* **Script de Despliegue en Producción:** [`src/deploy/vercel_deployer.py`](file:///Users/fabiancampoverde/Desktop/antigravity%202026/src/deploy/vercel_deployer.py)
