-- ============================================
-- VISITAS SFERA - Update v2
-- Cole no SQL Editor do Supabase e clique Run
-- ============================================

-- Endereços residenciais das supervisoras
UPDATE supervisoras SET
  endereco_residencial = 'Rua Roque Porcaro Junior, 267, ap 301, Centro',
  cidade_residencial = 'Manhumirim'
WHERE nome_curto = 'MAFORTES';

UPDATE supervisoras SET
  endereco_residencial = 'Vila Wladimir da Silva Araújo, 90, ap 302, Esplanada',
  cidade_residencial = 'Caratinga'
WHERE nome_curto = 'LEIDI';

UPDATE supervisoras SET
  endereco_residencial = 'Rua Morais e Castro, 165, ap 201, Alto dos Passos',
  cidade_residencial = 'Juiz de Fora'
WHERE nome_curto = 'CANTIERI';

UPDATE supervisoras SET
  endereco_residencial = 'Estrada do Coelho, 997, casa 1',
  cidade_residencial = 'São Gonçalo'
WHERE nome_curto = 'MIRELE';

UPDATE supervisoras SET
  endereco_residencial = 'Rua Cambaúba, 520/201, Jardim Guanabara, Ilha do Governador',
  cidade_residencial = 'Rio de Janeiro'
WHERE nome_curto = 'PATRICIA';

-- ============================================
-- NOVAS TABELAS
-- ============================================

-- Tipo de dia da supervisora
CREATE TABLE IF NOT EXISTS dias_supervisora (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  supervisora_id uuid REFERENCES supervisoras(id),
  data date NOT NULL DEFAULT CURRENT_DATE,
  tipo text NOT NULL DEFAULT 'visitas' CHECK (tipo IN ('visitas','escritorio','demanda')),
  descricao text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(supervisora_id, data)
);

-- Coluna para mídia nos registros
ALTER TABLE registros_visita ADD COLUMN IF NOT EXISTS media_url text;
ALTER TABLE registros_visita ADD COLUMN IF NOT EXISTS media_tipo text; -- foto, video, arquivo

-- Plano de ação: acompanhamento entre visitas
CREATE TABLE IF NOT EXISTS plano_acao_revisao (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  registro_original_id uuid REFERENCES registros_visita(id),
  visita_revisao_id uuid REFERENCES visitas(id),
  loja_id uuid REFERENCES lojas(id),
  status text CHECK (status IN ('concluido','andamento','pendente')),
  observacao text,
  created_at timestamptz DEFAULT now()
);

-- RLS para novas tabelas
ALTER TABLE dias_supervisora ENABLE ROW LEVEL SECURITY;
ALTER TABLE plano_acao_revisao ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON dias_supervisora FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON plano_acao_revisao FOR ALL USING (true) WITH CHECK (true);
