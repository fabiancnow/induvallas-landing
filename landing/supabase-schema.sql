-- ========================================================
-- TABLA DE LEADS - FILTRO DE CUALIFICACIÓN MOFU (INDUVALLAS)
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
    estado TEXT DEFAULT 'nuevo'
);

-- Habilitar Row Level Security (RLS)
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- Permitir que la clave pública (anon) pueda insertar registros desde la Landing Page
DROP POLICY IF EXISTS "Permitir insercion publica de leads" ON public.leads;
CREATE POLICY "Permitir insercion publica de leads" 
ON public.leads 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Permitir lectura pública o autenticada para consulta y capturas
DROP POLICY IF EXISTS "Permitir lectura para gestion de leads" ON public.leads;
CREATE POLICY "Permitir lectura para gestion de leads" 
ON public.leads 
FOR SELECT 
TO anon, authenticated 
USING (true);

-- Permitir actualización de estado del embudo comercial desde el Panel de Ventas (CRM Admin)
DROP POLICY IF EXISTS "Permitir actualizacion de estado en CRM" ON public.leads;
CREATE POLICY "Permitir actualizacion de estado en CRM"
ON public.leads
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);

