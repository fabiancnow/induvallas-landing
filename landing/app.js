// ========================================================
// INDUVALLAS - CAPTURA DE LEADS Y CONEXIÓN SUPABASE
// ========================================================

// Configuración de Supabase
const SUPABASE_CONFIG = {
  url: window.__SUPABASE_URL__ || "https://rgkcbbtwqwumlvubpulb.supabase.co",
  anonKey: window.__SUPABASE_ANON_KEY__ || "sb_publishable_XBao_xLme66eTSd3_PKLLw_PKuq0s4c"
};

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("leadFilterForm");
  const submitBtn = document.getElementById("submitBtn");
  const btnText = submitBtn.querySelector(".btn-text");
  const btnLoader = submitBtn.querySelector(".btn-loader");
  const feedback = document.getElementById("formFeedback");

  if (!form) return;

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    feedback.style.display = "none";
    feedback.className = "form-feedback";

    // Extraer datos del formulario
    const nombre = document.getElementById("nombre").value.trim();
    const empresa = document.getElementById("empresa").value.trim();
    const cargo = document.getElementById("cargo").value.trim();
    const email = document.getElementById("email").value.trim();
    const telefono = document.getElementById("telefono").value.trim();
    const presupuesto = document.getElementById("presupuesto").value;
    const necesidad_principal = document.getElementById("necesidad_principal").value;

    // Obtener ciudades seleccionadas
    const checkedCiudades = Array.from(
      document.querySelectorAll('input[name="ciudades"]:checked')
    ).map((cb) => cb.value);

    // Validación básica de campos requeridos
    if (!nombre || !empresa || !email || !telefono || !presupuesto || !necesidad_principal) {
      showFeedback("Por favor completa todos los campos obligatorios marcados con (*).", "error");
      return;
    }

    if (checkedCiudades.length === 0) {
      showFeedback("Por favor selecciona al menos una ciudad o zona de interés.", "error");
      return;
    }

    const payload = {
      nombre,
      empresa,
      cargo: cargo || "No especificado",
      email,
      telefono,
      presupuesto,
      ciudades: checkedCiudades,
      necesidad_principal,
      estado: "nuevo"
    };

    // Estado visual de carga
    submitBtn.disabled = true;
    btnText.style.display = "none";
    btnLoader.style.display = "inline";

    try {
      // Inserción directa en la API REST de Supabase (PostgREST)
      const response = await fetch(`${SUPABASE_CONFIG.url}/rest/v1/leads`, {
        method: "POST",
        headers: {
          "apikey": SUPABASE_CONFIG.anonKey,
          "Authorization": `Bearer ${SUPABASE_CONFIG.anonKey}`,
          "Content-Type": "application/json",
          "Prefer": "return=representation"
        },
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.message || `Error del servidor (${response.status})`);
      }

      // Éxito
      showFeedback(
        `✅ ¡Excelente, ${nombre}! Tu solicitud para "${empresa}" ha sido registrada. Un planner comercial se comunicará contigo al ${telefono} con el mapa de ubicaciones disponibles.`,
        "success"
      );
      form.reset();

    } catch (err) {
      console.error("Error al registrar lead:", err);
      showFeedback(
        `Hubo un inconveniente al conectar con el servidor: ${err.message}. Verifica las credenciales de Supabase.`,
        "error"
      );
    } finally {
      submitBtn.disabled = false;
      btnText.style.display = "inline";
      btnLoader.style.display = "none";
    }
  });

  function showFeedback(message, type) {
    feedback.textContent = message;
    feedback.className = `form-feedback ${type}`;
    feedback.style.display = "block";
    feedback.scrollIntoView({ behavior: "smooth", block: "nearest" });
  }

  // Simulador de Telemetría y Flujo en Tiempo Real (Efecto Motion Site)
  const counterEl = document.getElementById("liveCounter");
  if (counterEl) {
    let currentCount = 85420;
    setInterval(() => {
      const delta = Math.floor(Math.random() * 3) + 1;
      currentCount += delta;
      counterEl.textContent = currentCount.toLocaleString("es-EC");
    }, 2600);
  }
});
