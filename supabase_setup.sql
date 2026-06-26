-- ============================================
-- VISITAS SFERA - Setup do Banco de Dados
-- Cole este SQL no Supabase SQL Editor
-- ============================================

-- Supervisoras
CREATE TABLE IF NOT EXISTS supervisoras (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nome text NOT NULL,
  nome_curto text NOT NULL,
  email text NOT NULL UNIQUE,
  endereco_residencial text,
  cidade_residencial text,
  ativo boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Lojas
CREATE TABLE IF NOT EXISTS lojas (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  codigo text NOT NULL UNIQUE,
  nome text NOT NULL,
  supervisora_id uuid REFERENCES supervisoras(id),
  email text,
  endereco text,
  cidade text,
  estado text,
  cep text,
  ativo boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Visitas
CREATE TABLE IF NOT EXISTS visitas (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  loja_id uuid REFERENCES lojas(id),
  supervisora_id uuid REFERENCES supervisoras(id),
  data_visita date NOT NULL DEFAULT CURRENT_DATE,
  hora_inicio timestamptz DEFAULT now(),
  hora_fim timestamptz,
  energia_time integer CHECK (energia_time BETWEEN 1 AND 5),
  status text DEFAULT 'aberta' CHECK (status IN ('aberta', 'encerrada')),
  email_gerente text,
  resumo_enviado boolean DEFAULT false,
  observacao_geral text,
  created_at timestamptz DEFAULT now()
);

-- Registros da visita (o que foi feito)
CREATE TABLE IF NOT EXISTS registros_visita (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  visita_id uuid REFERENCES visitas(id) ON DELETE CASCADE,
  categoria text NOT NULL CHECK (categoria IN ('atendimento','exposicao','elogio','demanda','plano_acao','campanha','outro')),
  descricao text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Templates de checklist
CREATE TABLE IF NOT EXISTS checklist_templates (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  titulo text NOT NULL,
  descricao text,
  ativo boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Itens dos templates
CREATE TABLE IF NOT EXISTS checklist_itens (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  template_id uuid REFERENCES checklist_templates(id) ON DELETE CASCADE,
  ordem integer DEFAULT 0,
  pergunta text NOT NULL
);

-- Respostas dos checklists por visita
CREATE TABLE IF NOT EXISTS checklist_respostas (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  visita_id uuid REFERENCES visitas(id) ON DELETE CASCADE,
  template_id uuid REFERENCES checklist_templates(id),
  item_id uuid REFERENCES checklist_itens(id),
  resposta text CHECK (resposta IN ('sim','nao','parcial','na')),
  observacao text,
  created_at timestamptz DEFAULT now()
);

-- ============================================
-- DADOS INICIAIS - Supervisoras
-- ============================================
INSERT INTO supervisoras (nome, nome_curto, email) VALUES
  ('Juliana Cantieri', 'CANTIERI', 'juliana.cantieri@franquiasboticario.com'),
  ('Juliana Mafortes', 'MAFORTES', 'juliana.mafortes@franquiasboticario.com'),
  ('Leidinalva Soares', 'LEIDI', 'leidinalva.soares@franquiasboticario.com'),
  ('Patricia Baleixo', 'PATRICIA', 'patricia.baleixo@sferamultifranquias.com'),
  ('Mirele Botelho', 'MIRELE', 'mirelle.cutrim@franquiasboticario.com')
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- DADOS INICIAIS - Lojas
-- ============================================
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21476', 'MISTER', s.id, 'loja.mister@franquiasboticario.com', 'Av. Presidente Getulio Vargas, 675 - LJ 158', 'Juiz de Fora', 'MG', '36013-010' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21477', 'HALFELD', s.id, 'loja.halfeld@franquiasboticario.com', 'R. Halfeld, 607 - Centro', 'Juiz de Fora', 'MG', '36010-002' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21478', 'CARREFOUR MG', s.id, 'loja.jf.carrefour@franquiasboticario.com', 'Av. Barão do Rio Branco, 5001 - LJ 11', 'Juiz de Fora', 'MG', '36026-500' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21479', 'ST CRUZ', s.id, 'loja.santacruz@franquiasboticario.com', 'R. São Sebastião, 516 - LJ 1171', 'Juiz de Fora', 'MG', '36013-260' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21480', 'ALAMEDA', s.id, 'loja.alameda@franquiasboticario.com', 'R. Moraes e Castro, 300 LJ 105', 'Juiz de Fora', 'MG', '36025-160' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21468', 'INDEPENDENCIA', s.id, 'loja.independencia@franquiasboticario.com', 'Av. Presidente Itamar Franco, 3.600 - LJ 138', 'Juiz de Fora', 'MG', '36025-290' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21481', 'MARECHAL', s.id, 'loja.marechal@franquiasboticario.com', 'R. Marechal Deodoro, 344', 'Juiz de Fora', 'MG', '36013-001' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21482', 'JARDIM NORTE', s.id, 'loja.jn@franquiasboticario.com', 'Av. Brasil, 6345 - LJ 1104', 'Juiz de Fora', 'MG', '36080-060' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21484', 'GALERIA', s.id, 'loja.3r.galeria@franquiasboticario.com', 'R. Dr. Walmir Peçanha, 20 - LJ 112', 'Três Rios', 'RJ', '25802-180' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21486', 'QUIOSQUE 3 RIOS', s.id, 'loja.3r.shopping@franquiasboticario.com', 'Av. Barão do Rio Branco, 303 - QSQ 05', 'Três Rios', 'RJ', '25804-010' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23316', 'CARANDAÍ', s.id, 'loja.carandai.mg@franquiasboticario.com', 'Av. Maria de Melo Baeta, 95 - Centro', 'Carandaí', 'MG', '36280-001' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23317', 'BARROSO', s.id, 'loja.barroso.mg@franquiasboticario.com', 'R. Cel. Artur Napoleão, 71 - Centro', 'Barroso', 'MG', '36295-038' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23295', 'ST DUMONT', s.id, 'loja.santosdumont.mg@franquiasboticario.com', 'R. Antonio Ladeira 120 - Centro', 'Santos Dumont', 'MG', '36240-030' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;

-- LEIDI
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23453', 'CARATINGA OLEGÁRIO', s.id, 'loja.caratinga.olegario.mg@franquiasboticario.com', 'Avenida Olegário Maciel, 163 - Centro', 'Caratinga', 'MG', '35300-365' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23435', 'CARATINGA RAUL SOARES', s.id, 'loja.caratinga.raulsoares.mg@franquiasboticario.com', 'R. Raul Soares, 179 - Centro', 'Caratinga', 'MG', '35300-020' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23434', 'INHAPIM', s.id, 'loja.inhapim.mg@franquiasboticario.com', 'R. Osvaldo Silva Araujo, 275 - Centro', 'Inhapim', 'MG', '35330-000' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '22553', 'IPANEMA', s.id, 'loja.ipanema.mg@franquiasboticario.com', 'Av. 7 de Setembro, 517 - Centro', 'Ipanema', 'MG', '36950-000' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '22552', 'RAUL SOARES', s.id, 'loja.raul.mg@franquiasboticario.com', 'Av. Getulio Vargas, 339 - Centro', 'Raul Soares', 'MG', '35350-000' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '24064', 'AIMORÉS', s.id, 'loja.aimores.mg@franquiasboticario.com', 'Av. Raul Soares, 184 - Centro', 'Aimorés', 'MG', '35200-970' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;

-- MAFORTES
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23452', 'CARANGOLA', s.id, 'loja.carangola.mg@franquiasboticario.com', 'R. Pedro de Oliveira, 154 - Centro', 'Carangola', 'MG', '36800-082' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '23451', 'ESPERA FELIZ', s.id, 'loja.esperafeliz.mg@franquiasboticario.com', 'R. Fioravante Padula, 176 - Centro', 'Espera Feliz', 'MG', '36830-000' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '22586', 'LEOPOLDINA', s.id, 'loja.leopoldina.mg@franquiasboticario.com', 'R. Barão de Cotegipe, 322 - Centro', 'Leopoldina', 'MG', '36700-084' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '22554', 'ALÉM PARAÍBA', s.id, 'loja.alem.mg@franquiasboticario.com', 'R. Cel. Oscar Cortes, 156 - Porto Novo', 'Além Paraíba', 'MG', '36660-000' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '22561', 'MANHUMIRIM', s.id, 'loja.manhumirim.mg@franquiasboticario.com', 'R. Agenor Carlos Werner, 29 - Centro', 'Manhumirim', 'MG', '36970-000' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '22562', 'MANHUAÇU', s.id, 'loja.manhuacu.mg@franquiasboticario.com', 'Praça 5 de Novembro, 315 - Centro', 'Manhuaçu', 'MG', '36900-091' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;

-- MIRELE
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '19836', 'RODO', s.id, 'loja.rodo@franquiasboticario.com', 'R. Dr. Feliciano Sodré, 163', 'São Gonçalo', 'RJ', '24440-440' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '19837', 'CARREFOUR RJ', s.id, 'loja.carrefour@franquiasboticario.com', 'R. Dr. Alfredo Backer, 500 - LJ 38', 'São Gonçalo', 'RJ', '24452-005' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '19847', 'GUANABARA', s.id, 'loja.guanabara@franquiasboticario.com', 'Av. Jornalista Roberto Marinho, 221 - Box 219', 'São Gonçalo', 'RJ', '24451-715' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '19939', 'SÃO GONÇALO SHOPPING', s.id, 'loja.saogoncalo@franquiasboticario.com', 'Av. São Gonçalo, 100 - LJ 264/265', 'São Gonçalo', 'RJ', '24466-315' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '19985', 'PARTAGE', s.id, 'loja.partage@franquiasboticario.com', 'Av. Presidente Kennedy, 425 - 2º Piso LJ 224/225', 'São Gonçalo', 'RJ', '24445-000' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20025', 'ALCANTARA', s.id, 'loja.alcantara@franquiasboticario.com', 'Praça Carlos Gianelli, 67 - Lote 2', 'São Gonçalo', 'RJ', '24710-465' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;

-- PATRICIA
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20460', 'NORTE 1', s.id, 'loja.norte1@franquiasboticario.com', 'Av. D. Helder Câmara, 5332 - 1º Piso LJ 3301', 'Rio de Janeiro', 'RJ', '20771-004' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20502', 'NORTE 2', s.id, 'loja.norte2@franquiasboticario.com', 'Av. D. Helder Câmara, 5332 - 2º Piso LJ 3601', 'Rio de Janeiro', 'RJ', '20771-004' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20738', 'POLO 1', s.id, 'loja.polo1@franquiasboticario.com', 'Estrada do Portela, 99 - LJ 171', 'Rio de Janeiro', 'RJ', '21351-901' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20739', 'SHOP MADUREIRA', s.id, 'loja.shopping.madureira@franquiasboticario.com', 'Estrada do Portela, 222, LJ 297', 'Rio de Janeiro', 'RJ', '21351-051' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20782', 'SULACAP', s.id, 'loja.sulacap@franquiasboticario.com', 'Av. Marechal Fontenelle, 3545, LJ 154', 'Rio de Janeiro', 'RJ', '21750-000' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20786', 'MERCADÃO', s.id, 'loja.mercadao@franquiasboticario.com', 'Av. Marechal Fontenelle, 3545, LJ 154', 'Rio de Janeiro', 'RJ', '21750-000' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '20902', 'CALÇADÃO', s.id, 'loja.calcadao.madureira@franquiasboticario.com', 'Av. Ministro Edgard Romero, 55 A', 'Rio de Janeiro', 'RJ', '21350-301' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '21070', 'VALQUEIRE', s.id, 'loja.valqueire@franquiasboticario.com', 'R. das Dálias, 20, LJ B', 'Rio de Janeiro', 'RJ', '21330-740' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '24128', 'GUANABARA CAMPINHO', s.id, 'loja.campinho@franquiasboticario.com', 'Av. Ernani Cardoso, 350 - Lote 01', 'Cascadura', 'RJ', '21310-310' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep)
SELECT '910595', 'QDB', s.id, 'loja.norte3@franquiasqdb.com', 'Av. D. Helder Câmara, 5332 - 2º Piso LJ 3201', 'Cachambi', 'RJ', '20771-004' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;

-- ============================================
-- RLS - Acesso público para o app funcionar
-- ============================================
ALTER TABLE supervisoras ENABLE ROW LEVEL SECURITY;
ALTER TABLE lojas ENABLE ROW LEVEL SECURITY;
ALTER TABLE visitas ENABLE ROW LEVEL SECURITY;
ALTER TABLE registros_visita ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_respostas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON supervisoras FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON lojas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON visitas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON registros_visita FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON checklist_templates FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON checklist_itens FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON checklist_respostas FOR ALL USING (true) WITH CHECK (true);
