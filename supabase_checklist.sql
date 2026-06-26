-- ============================================
-- VISITAS SFERA - Checklist Visão Geral de Loja
-- Cole no SQL Editor do Supabase e clique Run
-- ============================================

-- 1. Adicionar colunas extras na tabela de itens
ALTER TABLE checklist_itens ADD COLUMN IF NOT EXISTS secao text;
ALTER TABLE checklist_itens ADD COLUMN IF NOT EXISTS permite_chamado boolean DEFAULT false;

-- 2. Adicionar colunas extras nas respostas
ALTER TABLE checklist_respostas ADD COLUMN IF NOT EXISTS avaliacao text CHECK (avaliacao IN ('pessimo','ruim','regular','bom','otimo'));
ALTER TABLE checklist_respostas ADD COLUMN IF NOT EXISTS media_url text;
ALTER TABLE checklist_respostas ADD COLUMN IF NOT EXISTS chamado_numero text;
ALTER TABLE checklist_respostas ADD COLUMN IF NOT EXISTS precisa_chamado boolean DEFAULT false;

-- 3. Inserir template
INSERT INTO checklist_templates (id, titulo, descricao) VALUES
  ('11111111-0000-0000-0000-000000000001', 'Visão Geral de Loja', 'Visita Supervisão O Boticário Sfera 2025 — 83 itens')
ON CONFLICT DO NOTHING;

-- 4. Inserir itens (83 itens em 8 seções)
DO $$
DECLARE tid uuid := '11111111-0000-0000-0000-000000000001';
BEGIN

-- VITRINE / FACHADA
INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 1,  'VITRINE / FACHADA', 'O interior da vitrine e os vidros estão limpos? Incluindo fachada e logotipo?', true),
(tid, 2,  'VITRINE / FACHADA', 'Todas as lâmpadas estão funcionando', true),
(tid, 3,  'VITRINE / FACHADA', 'A iluminação está posicionada corretamente', true),
(tid, 4,  'VITRINE / FACHADA', 'Está precificada de acordo com o guia', false),
(tid, 5,  'VITRINE / FACHADA', 'A Pintura da fachada está de acordo?', true),
(tid, 6,  'VITRINE / FACHADA', 'Marquise está de acordo?', true),
(tid, 7,  'VITRINE / FACHADA', 'Rodapé e pedra de mármore está de acordo?', true);

-- SALÃO DE VENDAS
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

-- VISUAL MERCHANDISING
INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 21, 'VISUAL MERCHANDISING', 'Os acessórios estão bem expostos? Podemos expor mais? Onde estão alocados?', false),
(tid, 22, 'VISUAL MERCHANDISING', 'Os produtos estão com etiqueta de Prove e Lacre de segurança', false),
(tid, 23, 'VISUAL MERCHANDISING', 'Todos os mobiliários estão sortidos de acordo com a sua capacidade', false),
(tid, 24, 'VISUAL MERCHANDISING', 'Os produtos expostos estão dentro da validade? Onde estão separados os produtos próximos da validade?', false),
(tid, 25, 'VISUAL MERCHANDISING', 'Os armários estão bem abastecidos?', false),
(tid, 26, 'VISUAL MERCHANDISING', 'Os demonstradores estão com a quantidade adequada para exposição?', false),
(tid, 27, 'VISUAL MERCHANDISING', 'O salão de vendas está precificado?', false);

-- BUROCRÁTICO
INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 28, 'BUROCRÁTICO', 'Escala de limpeza e seção de categorias está exposta em local acessível aos colaboradores?', false),
(tid, 29, 'BUROCRÁTICO', 'Todos os funcionários estão com os treinamentos acima de 90%?', false),
(tid, 30, 'BUROCRÁTICO', 'Está sendo feito o controle de banco de horas (faltas, ausências) no Ponto mais?', false),
(tid, 31, 'BUROCRÁTICO', 'O ponto está sendo registrado de maneira correta? (entrada e saída)', false),
(tid, 32, 'BUROCRÁTICO', 'Na saída há verificação de bolsa dos funcionários de forma discreta e individual', false),
(tid, 33, 'BUROCRÁTICO', 'O cofre está trancado? Com a chave com a gerente? O acumulado está de acordo com a CIT?', false),
(tid, 34, 'BUROCRÁTICO', 'Todos os documentos fiscais estão em local de fácil acesso', false),
(tid, 35, 'BUROCRÁTICO', 'Fundo de caixa está correto?', false);

-- ADMINISTRAÇÃO DE PESSOAL
INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 36, 'ADMINISTRAÇÃO DE PESSOAL', 'Os funcionários estão com uniforme padrão atual em bom estado', false),
(tid, 37, 'ADMINISTRAÇÃO DE PESSOAL', 'Equipe bem apresentável? (cabelo, barba, maquiagem e unhas)', false),
(tid, 38, 'ADMINISTRAÇÃO DE PESSOAL', 'Os armários dos funcionários estão em bom estado e identificados?', true);

-- ESTOQUE
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

-- CAIXAS
INSERT INTO checklist_itens (template_id, ordem, secao, pergunta, permite_chamado) VALUES
(tid, 64, 'CAIXAS', 'Balcão pré venda está arrumado e limpo?', false),
(tid, 65, 'CAIXAS', 'O caixa está limpo, organizado e abastecido (embalagens, bobinas etc)', false),
(tid, 66, 'CAIXAS', 'As sacolas e embalagens de presente são utilizadas corretamente', false),
(tid, 67, 'CAIXAS', 'Os expositores com as formas de pagamento e o código do consumidor estão visíveis para o cliente', false);

-- EQUIPAMENTOS
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

END $$;
