-- ==================================================================
-- VISITAS SFERA · SETUP COMPLETO (projeto novo)
-- Cole TUDO no SQL Editor do Supabase e clique RUN uma única vez.
-- Recria schema + dados de referência (supervisoras, lojas, checklist).
-- ==================================================================

-- ============ TABELAS ============

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

CREATE TABLE IF NOT EXISTS registros_visita (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  visita_id uuid REFERENCES visitas(id) ON DELETE CASCADE,
  categoria text NOT NULL CHECK (categoria IN ('atendimento','exposicao','elogio','demanda','plano_acao','campanha','outro')),
  descricao text NOT NULL,
  media_url text,
  media_tipo text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS checklist_templates (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  titulo text NOT NULL,
  descricao text,
  ativo boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS checklist_itens (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  template_id uuid REFERENCES checklist_templates(id) ON DELETE CASCADE,
  ordem integer DEFAULT 0,
  pergunta text NOT NULL,
  secao text,
  permite_chamado boolean DEFAULT false
);

CREATE TABLE IF NOT EXISTS checklist_respostas (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  visita_id uuid REFERENCES visitas(id) ON DELETE CASCADE,
  template_id uuid REFERENCES checklist_templates(id),
  item_id uuid REFERENCES checklist_itens(id),
  resposta text CHECK (resposta IN ('sim','nao','parcial','na')),
  avaliacao text CHECK (avaliacao IN ('pessimo','ruim','regular','bom','otimo','na')),
  observacao text,
  media_url text,
  chamado_numero text,
  precisa_chamado boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS dias_supervisora (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  supervisora_id uuid REFERENCES supervisoras(id),
  data date NOT NULL DEFAULT CURRENT_DATE,
  tipo text NOT NULL DEFAULT 'visitas' CHECK (tipo IN ('visitas','escritorio','demanda')),
  descricao text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(supervisora_id, data)
);

CREATE TABLE IF NOT EXISTS plano_acao_revisao (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  registro_original_id uuid REFERENCES registros_visita(id),
  visita_revisao_id uuid REFERENCES visitas(id),
  loja_id uuid REFERENCES lojas(id),
  status text CHECK (status IN ('concluido','andamento','pendente')),
  observacao text,
  created_at timestamptz DEFAULT now()
);

-- ============ RLS (acesso liberado p/ o app) ============
ALTER TABLE supervisoras        ENABLE ROW LEVEL SECURITY;
ALTER TABLE lojas               ENABLE ROW LEVEL SECURITY;
ALTER TABLE visitas             ENABLE ROW LEVEL SECURITY;
ALTER TABLE registros_visita    ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_itens     ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_respostas ENABLE ROW LEVEL SECURITY;
ALTER TABLE dias_supervisora    ENABLE ROW LEVEL SECURITY;
ALTER TABLE plano_acao_revisao  ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON supervisoras        FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON lojas               FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON visitas             FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON registros_visita    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON checklist_templates FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON checklist_itens     FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON checklist_respostas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON dias_supervisora    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON plano_acao_revisao  FOR ALL USING (true) WITH CHECK (true);

-- ============ SUPERVISORAS ============
INSERT INTO supervisoras (nome, nome_curto, email, endereco_residencial, cidade_residencial) VALUES
  ('Juliana Cantieri', 'CANTIERI', 'juliana.cantieri@franquiasboticario.com', 'Rua Morais e Castro, 165, ap 201, Alto dos Passos', 'Juiz de Fora'),
  ('Juliana Mafortes', 'MAFORTES', 'juliana.mafortes@franquiasboticario.com', 'Rua Roque Porcaro Junior, 267, ap 301, Centro', 'Manhumirim'),
  ('Leidinalva Soares', 'LEIDI', 'leidinalva.soares@franquiasboticario.com', 'Vila Wladimir da Silva Araújo, 90, ap 302, Esplanada', 'Caratinga'),
  ('Patricia Baleixo', 'PATRICIA', 'patricia.baleixo@sferamultifranquias.com', 'Rua Cambaúba, 520/201, Jardim Guanabara, Ilha do Governador', 'Rio de Janeiro'),
  ('Mirele Botelho', 'MIRELE', 'mirelle.cutrim@franquiasboticario.com', 'Estrada do Coelho, 997, casa 1', 'São Gonçalo')
ON CONFLICT (email) DO NOTHING;

-- ============ LOJAS ============
-- CANTIERI
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21476', 'MISTER', s.id, 'loja.mister@franquiasboticario.com', 'Av. Presidente Getulio Vargas, 675 - LJ 158', 'Juiz de Fora', 'MG', '36013-010' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21477', 'HALFELD', s.id, 'loja.halfeld@franquiasboticario.com', 'R. Halfeld, 607 - Centro', 'Juiz de Fora', 'MG', '36010-002' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21478', 'CARREFOUR MG', s.id, 'loja.jf.carrefour@franquiasboticario.com', 'Av. Barão do Rio Branco, 5001 - LJ 11', 'Juiz de Fora', 'MG', '36026-500' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21479', 'ST CRUZ', s.id, 'loja.santacruz@franquiasboticario.com', 'R. São Sebastião, 516 - LJ 1171', 'Juiz de Fora', 'MG', '36013-260' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21480', 'ALAMEDA', s.id, 'loja.alameda@franquiasboticario.com', 'R. Moraes e Castro, 300 LJ 105', 'Juiz de Fora', 'MG', '36025-160' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21468', 'INDEPENDENCIA', s.id, 'loja.independencia@franquiasboticario.com', 'Av. Presidente Itamar Franco, 3.600 - LJ 138', 'Juiz de Fora', 'MG', '36025-290' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21481', 'MARECHAL', s.id, 'loja.marechal@franquiasboticario.com', 'R. Marechal Deodoro, 344', 'Juiz de Fora', 'MG', '36013-001' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21482', 'JARDIM NORTE', s.id, 'loja.jn@franquiasboticario.com', 'Av. Brasil, 6345 - LJ 1104', 'Juiz de Fora', 'MG', '36080-060' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21484', 'GALERIA', s.id, 'loja.3r.galeria@franquiasboticario.com', 'R. Dr. Walmir Peçanha, 20 - LJ 112', 'Três Rios', 'RJ', '25802-180' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21486', 'QUIOSQUE 3 RIOS', s.id, 'loja.3r.shopping@franquiasboticario.com', 'Av. Barão do Rio Branco, 303 - QSQ 05', 'Três Rios', 'RJ', '25804-010' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23316', 'CARANDAÍ', s.id, 'loja.carandai.mg@franquiasboticario.com', 'Av. Maria de Melo Baeta, 95 - Centro', 'Carandaí', 'MG', '36280-001' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23317', 'BARROSO', s.id, 'loja.barroso.mg@franquiasboticario.com', 'R. Cel. Artur Napoleão, 71 - Centro', 'Barroso', 'MG', '36295-038' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23295', 'ST DUMONT', s.id, 'loja.santosdumont.mg@franquiasboticario.com', 'R. Antonio Ladeira 120 - Centro', 'Santos Dumont', 'MG', '36240-030' FROM supervisoras s WHERE s.nome_curto = 'CANTIERI' ON CONFLICT (codigo) DO NOTHING;
-- LEIDI
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23453', 'CARATINGA OLEGÁRIO', s.id, 'loja.caratinga.olegario.mg@franquiasboticario.com', 'Avenida Olegário Maciel, 163 - Centro', 'Caratinga', 'MG', '35300-365' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23435', 'CARATINGA RAUL SOARES', s.id, 'loja.caratinga.raulsoares.mg@franquiasboticario.com', 'R. Raul Soares, 179 - Centro', 'Caratinga', 'MG', '35300-020' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23434', 'INHAPIM', s.id, 'loja.inhapim.mg@franquiasboticario.com', 'R. Osvaldo Silva Araujo, 275 - Centro', 'Inhapim', 'MG', '35330-000' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '22553', 'IPANEMA', s.id, 'loja.ipanema.mg@franquiasboticario.com', 'Av. 7 de Setembro, 517 - Centro', 'Ipanema', 'MG', '36950-000' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '22552', 'RAUL SOARES', s.id, 'loja.raul.mg@franquiasboticario.com', 'Av. Getulio Vargas, 339 - Centro', 'Raul Soares', 'MG', '35350-000' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '24064', 'AIMORÉS', s.id, 'loja.aimores.mg@franquiasboticario.com', 'Av. Raul Soares, 184 - Centro', 'Aimorés', 'MG', '35200-970' FROM supervisoras s WHERE s.nome_curto = 'LEIDI' ON CONFLICT (codigo) DO NOTHING;
-- MAFORTES
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23452', 'CARANGOLA', s.id, 'loja.carangola.mg@franquiasboticario.com', 'R. Pedro de Oliveira, 154 - Centro', 'Carangola', 'MG', '36800-082' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '23451', 'ESPERA FELIZ', s.id, 'loja.esperafeliz.mg@franquiasboticario.com', 'R. Fioravante Padula, 176 - Centro', 'Espera Feliz', 'MG', '36830-000' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '22586', 'LEOPOLDINA', s.id, 'loja.leopoldina.mg@franquiasboticario.com', 'R. Barão de Cotegipe, 322 - Centro', 'Leopoldina', 'MG', '36700-084' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '22554', 'ALÉM PARAÍBA', s.id, 'loja.alem.mg@franquiasboticario.com', 'R. Cel. Oscar Cortes, 156 - Porto Novo', 'Além Paraíba', 'MG', '36660-000' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '22561', 'MANHUMIRIM', s.id, 'loja.manhumirim.mg@franquiasboticario.com', 'R. Agenor Carlos Werner, 29 - Centro', 'Manhumirim', 'MG', '36970-000' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '22562', 'MANHUAÇU', s.id, 'loja.manhuacu.mg@franquiasboticario.com', 'Praça 5 de Novembro, 315 - Centro', 'Manhuaçu', 'MG', '36900-091' FROM supervisoras s WHERE s.nome_curto = 'MAFORTES' ON CONFLICT (codigo) DO NOTHING;
-- MIRELE
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '19836', 'RODO', s.id, 'loja.rodo@franquiasboticario.com', 'R. Dr. Feliciano Sodré, 163', 'São Gonçalo', 'RJ', '24440-440' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '19837', 'CARREFOUR RJ', s.id, 'loja.carrefour@franquiasboticario.com', 'R. Dr. Alfredo Backer, 500 - LJ 38', 'São Gonçalo', 'RJ', '24452-005' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '19847', 'GUANABARA', s.id, 'loja.guanabara@franquiasboticario.com', 'Av. Jornalista Roberto Marinho, 221 - Box 219', 'São Gonçalo', 'RJ', '24451-715' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '19939', 'SÃO GONÇALO SHOPPING', s.id, 'loja.saogoncalo@franquiasboticario.com', 'Av. São Gonçalo, 100 - LJ 264/265', 'São Gonçalo', 'RJ', '24466-315' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '19985', 'PARTAGE', s.id, 'loja.partage@franquiasboticario.com', 'Av. Presidente Kennedy, 425 - 2º Piso LJ 224/225', 'São Gonçalo', 'RJ', '24445-000' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20025', 'ALCANTARA', s.id, 'loja.alcantara@franquiasboticario.com', 'Praça Carlos Gianelli, 67 - Lote 2', 'São Gonçalo', 'RJ', '24710-465' FROM supervisoras s WHERE s.nome_curto = 'MIRELE' ON CONFLICT (codigo) DO NOTHING;
-- PATRICIA
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20460', 'NORTE 1', s.id, 'loja.norte1@franquiasboticario.com', 'Av. D. Helder Câmara, 5332 - 1º Piso LJ 3301', 'Rio de Janeiro', 'RJ', '20771-004' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20502', 'NORTE 2', s.id, 'loja.norte2@franquiasboticario.com', 'Av. D. Helder Câmara, 5332 - 2º Piso LJ 3601', 'Rio de Janeiro', 'RJ', '20771-004' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20738', 'POLO 1', s.id, 'loja.polo1@franquiasboticario.com', 'Estrada do Portela, 99 - LJ 171', 'Rio de Janeiro', 'RJ', '21351-901' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20739', 'SHOP MADUREIRA', s.id, 'loja.shopping.madureira@franquiasboticario.com', 'Estrada do Portela, 222, LJ 297', 'Rio de Janeiro', 'RJ', '21351-051' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20782', 'SULACAP', s.id, 'loja.sulacap@franquiasboticario.com', 'Av. Marechal Fontenelle, 3545, LJ 154', 'Rio de Janeiro', 'RJ', '21750-000' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20786', 'MERCADÃO', s.id, 'loja.mercadao@franquiasboticario.com', 'Av. Marechal Fontenelle, 3545, LJ 154', 'Rio de Janeiro', 'RJ', '21750-000' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '20902', 'CALÇADÃO', s.id, 'loja.calcadao.madureira@franquiasboticario.com', 'Av. Ministro Edgard Romero, 55 A', 'Rio de Janeiro', 'RJ', '21350-301' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '21070', 'VALQUEIRE', s.id, 'loja.valqueire@franquiasboticario.com', 'R. das Dálias, 20, LJ B', 'Rio de Janeiro', 'RJ', '21330-740' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '24128', 'GUANABARA CAMPINHO', s.id, 'loja.campinho@franquiasboticario.com', 'Av. Ernani Cardoso, 350 - Lote 01', 'Cascadura', 'RJ', '21310-310' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;
INSERT INTO lojas (codigo, nome, supervisora_id, email, endereco, cidade, estado, cep) SELECT '910595', 'QDB', s.id, 'loja.norte3@franquiasqdb.com', 'Av. D. Helder Câmara, 5332 - 2º Piso LJ 3201', 'Cachambi', 'RJ', '20771-004' FROM supervisoras s WHERE s.nome_curto = 'PATRICIA' ON CONFLICT (codigo) DO NOTHING;

-- ============ CHECKLIST · TEMPLATE + 83 ITENS ============
INSERT INTO checklist_templates (id, titulo, descricao) VALUES
  ('11111111-0000-0000-0000-000000000001', 'Visão Geral de Loja', 'Visita Supervisão O Boticário Sfera 2025 — 83 itens')
ON CONFLICT DO NOTHING;

DO $$
DECLARE tid uuid := '11111111-0000-0000-0000-000000000001';
BEGIN
IF NOT EXISTS (SELECT 1 FROM checklist_itens WHERE template_id = tid) THEN

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 1,  'VITRINE / FACHADA', 'O interior da vitrine e os vidros estão limpos? Incluindo fachada e logotipo?', true),
(tid, 2,  'VITRINE / FACHADA', 'Todas as lâmpadas estão funcionando', true),
(tid, 3,  'VITRINE / FACHADA', 'A iluminação está posicionada corretamente', true),
(tid, 4,  'VITRINE / FACHADA', 'Está precificada de acordo com o guia', false),
(tid, 5,  'VITRINE / FACHADA', 'A Pintura da fachada está de acordo?', true),
(tid, 6,  'VITRINE / FACHADA', 'Marquise está de acordo?', true),
(tid, 7,  'VITRINE / FACHADA', 'Rodapé e pedra de mármore está de acordo?', true);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 8,  'SALÃO DE VENDAS', 'Tv ligada? em perfeito estado? Controle guardado e em bom estado?', true),
(tid, 9,  'SALÃO DE VENDAS', 'A limpeza da loja está de acordo? Piso, teto, paredes, espelhos, porta', false),
(tid, 10, 'SALÃO DE VENDAS', 'O volume do som está adequado', false),
(tid, 11, 'SALÃO DE VENDAS', 'A rádio é o Boticário?', false),
(tid, 12, 'SALÃO DE VENDAS', 'A pintura interna da loja está em bom estado', true),
(tid, 13, 'SALÃO DE VENDAS', 'Extintores de incêndio estão sinalizados, no local correto e dentro do prazo de vencimento', true),
(tid, 14, 'SALÃO DE VENDAS', 'Instalações elétricas na loja OK? (Fios aparentes/soltos, lâmpadas queimadas, etc)', true),
(tid, 15, 'SALÃO DE VENDAS', 'Instalações hidráulicas na loja OK? (torneiras e canos com vazamento, etc.)', true),
(tid, 16, 'SALÃO DE VENDAS', 'Toaletes e copa limpos e arrumados', false),
(tid, 17, 'SALÃO DE VENDAS', 'Ar-condicionado funcionando? As saídas do ar estão limpas?', true),
(tid, 18, 'SALÃO DE VENDAS', 'Cortina de ar está funcionando? As saídas do ar estão limpas?', true),
(tid, 19, 'SALÃO DE VENDAS', 'Sistema do alarme (anti-furto) e alarme da loja estão funcionando adequadamente', true),
(tid, 20, 'SALÃO DE VENDAS', 'Os ex colaboradores já foram excluídos do sistema de alarmes?', false);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 21, 'VISUAL MERCHANDISING', 'Os acessórios estão bem expostos? Podemos expor mais? Onde estão alocados?', false),
(tid, 22, 'VISUAL MERCHANDISING', 'Os produtos estão com etiqueta de Prove e Lacre de segurança', false),
(tid, 23, 'VISUAL MERCHANDISING', 'Todos os mobiliários estão sortidos de acordo com a sua capacidade', false),
(tid, 24, 'VISUAL MERCHANDISING', 'Os produtos expostos estão dentro da validade? Onde estão separados os produtos próximos da validade?', false),
(tid, 25, 'VISUAL MERCHANDISING', 'Os armários estão bem abastecidos?', false),
(tid, 26, 'VISUAL MERCHANDISING', 'Os demonstradores estão com a quantidade adequada para exposição?', false),
(tid, 27, 'VISUAL MERCHANDISING', 'O salão de vendas está precificado?', false);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 28, 'BUROCRÁTICO', 'Escala de limpeza e seção de categorias está exposta em local acessível aos colaboradores?', false),
(tid, 29, 'BUROCRÁTICO', 'Todos os funcionários estão com os treinamentos acima de 90%?', false),
(tid, 30, 'BUROCRÁTICO', 'Está sendo feito o controle de banco de horas (faltas, ausências) no Ponto mais?', false),
(tid, 31, 'BUROCRÁTICO', 'O ponto está sendo registrado de maneira correta? (entrada e saída)', false),
(tid, 32, 'BUROCRÁTICO', 'Na saída há verificação de bolsa dos funcionários de forma discreta e individual', false),
(tid, 33, 'BUROCRÁTICO', 'O cofre está trancado? Com a chave com a gerente? O acumulado está de acordo com a CIT?', false),
(tid, 34, 'BUROCRÁTICO', 'Todos os documentos fiscais estão em local de fácil acesso', false),
(tid, 35, 'BUROCRÁTICO', 'Fundo de caixa está correto?', false);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 36, 'ADMINISTRAÇÃO DE PESSOAL', 'Os funcionários estão com uniforme padrão atual em bom estado', false),
(tid, 37, 'ADMINISTRAÇÃO DE PESSOAL', 'Equipe bem apresentável? (cabelo, barba, maquiagem e unhas)', false),
(tid, 38, 'ADMINISTRAÇÃO DE PESSOAL', 'Os armários dos funcionários estão em bom estado e identificados?', true);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 39, 'ESTOQUE', 'Mercadorias estocadas em local apropriado', false),
(tid, 40, 'ESTOQUE', 'As prateleiras estão sinalizadas por categoria', false),
(tid, 41, 'ESTOQUE', 'Área do estoque está limpa e organizada', false),
(tid, 42, 'ESTOQUE', 'As embalagens e bobinas estão armazenadas corretamente e de fácil acesso', false),
(tid, 43, 'ESTOQUE', 'A sala do ar condicionado está livre de mercadorias e entulhos', false),
(tid, 44, 'ESTOQUE', 'O enxoval permanente está organizado corretamente', false),
(tid, 45, 'ESTOQUE', 'Os acrílicos e suportes estão bem alocados e protegidos', false),
(tid, 46, 'ESTOQUE', 'Os produtos com defeitos e os produtos sem embalagem estão separados em local específico', false),
(tid, 47, 'ESTOQUE', 'A porta de acesso ao estoque permanece fechada', false),
(tid, 48, 'ESTOQUE', 'Reciclagem organizada?', false),
(tid, 49, 'ESTOQUE', 'Geladeira está limpa?', false),
(tid, 50, 'ESTOQUE', 'Micro-ondas está limpo?', false),
(tid, 51, 'ESTOQUE', 'Pia da cozinha está limpa?', false),
(tid, 52, 'ESTOQUE', 'Local de alimentação está limpo e organizado?', false),
(tid, 53, 'ESTOQUE', 'Os armários de guardar objetos pessoais estão organizados?', false),
(tid, 54, 'ESTOQUE', 'Os acessos às condensadoras de ar estão trancados? Para evitar furto?', true),
(tid, 55, 'ESTOQUE', 'As lâmpadas estão funcionando?', true),
(tid, 56, 'ESTOQUE', 'O Nobreak do rack está funcionando?', true),
(tid, 57, 'ESTOQUE', 'A loja possui modem de contingência? Está funcionando corretamente?', true),
(tid, 58, 'ESTOQUE', 'DVR está ligado? E funcionando todas as câmeras?', true),
(tid, 59, 'ESTOQUE', 'Os celulares dos colaboradores estão guardados no local definido pela gerência?', false),
(tid, 60, 'ESTOQUE', 'Os objetos pessoais dos colaboradores estão organizados em local definido pela gerência?', false),
(tid, 61, 'ESTOQUE', 'O abastecimento de material de limpeza está ok?', false),
(tid, 62, 'ESTOQUE', 'O material de limpeza da loja está em local apropriado?', false),
(tid, 63, 'ESTOQUE', 'O abastecimento de material de escritório está ok?', false);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 64, 'CAIXAS', 'Balcão pré venda está arrumado e limpo?', false),
(tid, 65, 'CAIXAS', 'O caixa está limpo, organizado e abastecido (embalagens, bobinas etc)', false),
(tid, 66, 'CAIXAS', 'As sacolas e embalagens de presente são utilizadas corretamente', false),
(tid, 67, 'CAIXAS', 'Os expositores com as formas de pagamento e o código do consumidor estão visíveis para o cliente', false);

INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 68, 'EQUIPAMENTOS', 'Computador funcionando, precisa de algum reparo?', true),
(tid, 69, 'EQUIPAMENTOS', 'As impressoras estão funcionando', true),
(tid, 70, 'EQUIPAMENTOS', 'Linha telefônica funcionando', true),
(tid, 71, 'EQUIPAMENTOS', 'Rede banda larga (internet) funcionando', true),
(tid, 72, 'EQUIPAMENTOS', 'TEF, leitor óptico, PDV, POS e Mob pin estão funcionando?', true),
(tid, 73, 'EQUIPAMENTOS', 'Todos os softwares da empresa estão funcionando', true),
(tid, 74, 'EQUIPAMENTOS', 'Sala de treinamento está funcionando?', true),
(tid, 75, 'EQUIPAMENTOS', 'A quantidade de mobshop está de acordo com o patrimônio?', false),
(tid, 76, 'EQUIPAMENTOS', 'Os mobs estão com película e capa ok?', true),
(tid, 77, 'EQUIPAMENTOS', 'Cartucheiras estão em bom estado e limpas?', false),
(tid, 78, 'EQUIPAMENTOS', 'Os mobs estão organizados para carregar? Todos estão com carregador?', false),
(tid, 79, 'EQUIPAMENTOS', 'A Bússola está atualizada?', false),
(tid, 80, 'EQUIPAMENTOS', 'O GI está aberto para acompanhamento dos indicadores em tempo real?', false),
(tid, 81, 'EQUIPAMENTOS', 'Canal de denúncia (ouvidoria) está exposto no estoque?', false),
(tid, 82, 'EQUIPAMENTOS', 'Estão com os cards de botirecicla NPS e Serviços de make?', false),
(tid, 83, 'EQUIPAMENTOS', 'Existe avaliação do mês de checklist de vendas de alguma consultora?', false);

END IF;
END $$;
