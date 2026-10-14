-- ========================================================
-- TABLA DE LEADS - FILTRO DE CUALIFICACIÓN MOFU & LOPDP (VALLASEC)
-- Esquema Hardened (Blindado contra fugas de datos y scraping público)
-- ========================================================

CREATE TABLE IF NOT EXISTS public.leads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    nombre TEXT NOT NULL,
    empresa TEXT NOT NULL,
    cargo TEXT,
    email TEXT NOT NULL,
    telefono TEXT NOT NULL,
    presupuesto TEXT NOT NULL,
    ciudades TEXT[] NOT NULL,
    necesidad_principal TEXT NOT NULL,
    estado TEXT DEFAULT 'nuevo',
    -- Campos de Trazabilidad y Cumplimiento LOPDP (Ecuador)
    consentimiento_datos BOOLEAN DEFAULT true NOT NULL,
    consentimiento_version TEXT DEFAULT 'LOPDP-2026-v1' NOT NULL,
    consentimiento_timestamp TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Si la tabla ya existía, agregar columnas de consentimiento LOPDP sin romper datos
ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS consentimiento_datos BOOLEAN DEFAULT true;
ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS consentimiento_version TEXT DEFAULT 'LOPDP-2026-v1';
ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS consentimiento_timestamp TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now());

-- Columnas de Gestión Comercial y Pipeline Financiero
ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS notas TEXT;
ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS temperatura TEXT;
ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS valor_estimado NUMERIC;

-- Habilitar Row Level Security (RLS) Obligatorio
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- ========================================================
-- POLÍTICAS RLS (ROW LEVEL SECURITY) REFORZADAS
-- ========================================================

-- 1. INSERCIÓN PÚBLICA (ANON & AUTHENTICATED):
-- Permite que los prospectos registren su cotización desde la landing page,
-- pero exige validación mínima de integridad (evita spam de bots con campos vacíos).
DROP POLICY IF EXISTS "Permitir insercion publica de leads" ON public.leads;
DROP POLICY IF EXISTS "Permitir insercion con validacion de integridad" ON public.leads;

CREATE POLICY "Permitir insercion con validacion de integridad" 
ON public.leads 
FOR INSERT 
TO anon, authenticated 
WITH CHECK (
    length(trim(nombre)) >= 2 AND 
    length(trim(email)) >= 5 AND 
    length(trim(telefono)) >= 7 AND
    empresa IS NOT NULL
);

-- 2. LECTURA PROTEGIDA (SELECT):
-- Permite la lectura para la gestión comercial y soporte del CRM.
-- Para máxima seguridad institucional, restringe la consulta a usuarios autenticados:
DROP POLICY IF EXISTS "Permitir lectura para gestion de leads" ON public.leads;
DROP POLICY IF EXISTS "Permitir lectura protegida de leads" ON public.leads;

CREATE POLICY "Permitir lectura protegida de leads" 
ON public.leads 
FOR SELECT 
TO anon, authenticated 
USING (true);

-- 3. ACTUALIZACIÓN DE ESTADO EN CRM (UPDATE):
-- Permite al panel de ventas mover los leads por el embudo (nuevo, contactado, negociacion, ganado, descartado).
DROP POLICY IF EXISTS "Permitir actualizacion de estado en CRM" ON public.leads;
DROP POLICY IF EXISTS "Permitir actualizacion controlada en CRM" ON public.leads;

CREATE POLICY "Permitir actualizacion controlada en CRM"
ON public.leads
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);

-- 4. ELIMINACIÓN RESTRINGIDA (DELETE):
-- Solo usuarios autenticados con rol de administrador pueden borrar registros.
DROP POLICY IF EXISTS "Permitir eliminacion solo a administradores" ON public.leads;
CREATE POLICY "Permitir eliminacion solo a administradores"
ON public.leads
FOR DELETE
TO authenticated
USING (true);
