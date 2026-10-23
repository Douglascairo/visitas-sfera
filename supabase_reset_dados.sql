-- ============================================
-- VISITAS SFERA - RESET DE DADOS (começar do zero)
-- ============================================
-- ⚠️ ATENÇÃO: operação IRREVERSÍVEL.
-- Apaga TODAS as visitas, demandas e histórico cadastrados pelas supervisoras.
-- MANTÉM a estrutura: supervisoras, lojas, checklist_templates, checklist_itens.
--
-- Rode em 2 etapas no SQL Editor do Supabase:
--   ETAPA 1: rode só o SELECT abaixo para ver quantos registros serão apagados.
--   ETAPA 2: confirmado, rode o TRUNCATE.
-- ============================================

-- -------- ETAPA 1: Conferência (quantos registros existem hoje) --------
SELECT 'visitas'              AS tabela, COUNT(*) AS registros FROM visitas
UNION ALL SELECT 'registros_visita',     COUNT(*) FROM registros_visita
UNION ALL SELECT 'checklist_respostas',  COUNT(*) FROM checklist_respostas
UNION ALL SELECT 'dias_supervisora',     COUNT(*) FROM dias_supervisora
UNION ALL SELECT 'plano_acao_revisao',   COUNT(*) FROM plano_acao_revisao
UNION ALL SELECT 'demandas_supervisora', COUNT(*) FROM demandas_supervisora
UNION ALL SELECT 'demandas_diretoria',   COUNT(*) FROM demandas_diretoria
UNION ALL SELECT 'prio_cache',           COUNT(*) FROM prio_cache
ORDER BY tabela;

-- -------- ETAPA 2: Apagar tudo (só rode após conferir a Etapa 1) --------
-- Se alguma tabela acusar "does not exist", remova a linha correspondente.
TRUNCATE TABLE
  checklist_respostas,
  registros_visita,
  plano_acao_revisao,
  dias_supervisora,
  demandas_supervisora,
  demandas_diretoria,
  visitas,
  prio_cache
RESTART IDENTITY CASCADE;

-- -------- Conferência final (tudo deve voltar 0) --------
SELECT 'visitas'              AS tabela, COUNT(*) AS registros FROM visitas
UNION ALL SELECT 'registros_visita',     COUNT(*) FROM registros_visita
UNION ALL SELECT 'checklist_respostas',  COUNT(*) FROM checklist_respostas
UNION ALL SELECT 'dias_supervisora',     COUNT(*) FROM dias_supervisora
UNION ALL SELECT 'plano_acao_revisao',   COUNT(*) FROM plano_acao_revisao
UNION ALL SELECT 'demandas_supervisora', COUNT(*) FROM demandas_supervisora
UNION ALL SELECT 'demandas_diretoria',   COUNT(*) FROM demandas_diretoria
UNION ALL SELECT 'prio_cache',           COUNT(*) FROM prio_cache
ORDER BY tabela;
