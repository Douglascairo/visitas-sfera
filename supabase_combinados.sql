-- ============================================
-- VISITAS SFERA - Tabela "Meus Combinados"
-- Cole no SQL Editor do Supabase e clique Run
-- ============================================
-- Combinados da supervisora com as gerentes (férias, folgas, acordos).
-- O app avisa 1 semana antes da data.

CREATE TABLE IF NOT EXISTS combinados (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  supervisora_id uuid REFERENCES supervisoras(id),
  loja_id uuid REFERENCES lojas(id),      -- opcional
  titulo text NOT NULL,
  data date NOT NULL,
  tipo text,                               -- detectado automaticamente (ferias/folga/evento/...)
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_combinados_sup_data ON combinados (supervisora_id, data);

ALTER TABLE combinados ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "allow_all" ON combinados;
CREATE POLICY "allow_all" ON combinados FOR ALL USING (true) WITH CHECK (true);
